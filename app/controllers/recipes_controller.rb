class RecipesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index, :show]
  before_action :deny_spammers!, only: [:create, :update, :destroy]
  invisible_captcha only: [:create, :update], on_spam: :redirect_spammers!

  # GET /recipes
  # GET /recipes.json
  def index
    @search = search_hash
    respond_to do |format|
      format.html { render :index }
      format.rss { render :layout => false }
      format.json { render :layout => false }
    end
  end

  # GET /recipes/1
  # GET /recipes/1.json
  def show
    @recipe = find_recipe
    raise AuthorizationException unless can_show?(@recipe)
    raise RecipeNotComplete unless @recipe.complete?
    @beerxml = BeerxmlImport.new(@recipe, @recipe.beerxml).parse
    @presenter = RecipePresenter.new(@recipe, @beerxml)
    Recipe.unscoped do
      commontator_thread_show(@recipe)
    end
    respond_to do |format|
      format.html { render :show }
      format.json { render :layout => false }
      format.xml {
        send_data @recipe.beerxml, {
          type: 'application/xml',
          disposition: 'attachment',
          filename: "#{@recipe.name}.xml"
        }
        @recipe.increment(:downloads).save!
      }
    end
  end

  # GET /recipes/new
  def new
    @recipe = Recipe.new
    @event = Event.find(params[:event_id]) if params[:event_id].present?

    if @event&.registration_closed?
      flash.alert = t(:'activerecord.errors.models.recipe.event_registration_closed')
      @event = nil
    end
  end

  # GET /recipes/1/edit
  def edit
    @recipe = find_recipe
    raise AuthorizationException unless current_user.can_modify?(@recipe)
  end

  # POST /recipes
  # POST /recipes.json
  def create
    @recipe = create_recipes!.last

    respond_to do |format|
      if @recipe.present? && @recipe.persisted?
        format.html { redirect_to redirect_path, notice: I18n.t(:'recipes.create.successful') }
        format.json { render :show, status: :created, location: @recipe }
      else
        format.html {
          if @recipe.present?
            flash[:error] = @recipe.errors.full_messages.to_sentence
          else
            flash[:error] = I18n.t(:'recipes.create.failed')
          end
          redirect_to new_recipe_path
        }
        format.json { render json: @recipe.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /recipes/1
  # PATCH/PUT /recipes/1.json
  def update
    @recipe = find_recipe
    raise AuthorizationException unless current_user.can_modify?(@recipe)

    respond_to do |format|
      if @recipe.update(recipe_params)
        import_beerxml(@recipe, params.dig(:recipe, :beerxml))
        format.html { redirect_to redirect_path, notice: I18n.t(:'recipes.update.successful') }
        format.json { render :show, status: :ok, location: @recipe }
        format.js { head :ok, location: @recipe }
      else
        format.html {
          flash[:error] = @recipe.errors.full_messages.to_sentence
          render :edit
        }
        format.json { render json: @recipe.errors, status: :unprocessable_entity }
        format.js { render layout: false, status: :unprocessable_entity, location: @recipe }
      end
    end
  end

  # DELETE /recipes/1
  # DELETE /recipes/1.json
  def destroy
    @recipe = find_recipe
    raise AuthorizationException unless current_user.can_modify?(@recipe)
    @recipe.destroy

    respond_to do |format|
      format.html { redirect_to recipes_url, notice: I18n.t(:'recipes.destroy.successful') }
      format.json { head :no_content }
    end
  end

  private
    def find_recipe
      Recipe.unscoped.find(params[:id])
    end

    def recipe_params
      params.require(:recipe).permit(:name, :description, :public)
    end

    def event_params
      params.require(:event).permit(:id, :medal, :category)
    end

    def registration_params
      params.require(:registration).permit(:register, :message)
    end

    def redirect_path
      if @recipe&.beerxml.present?
        @recipe
      else
        recipe_details_path(@recipe)
      end
    end

    def import_beerxml(recipe, beerxml)
      if beerxml.present?
        recipe.beerxml = beerxml.read
        BeerxmlImport.new(recipe, recipe.beerxml).run
        recipe.detail.save!
      end
      recipe.save!
      recipe
    end

    def new_recipe
      Recipe.new(recipe_params) do |recipe|
        recipe.user = current_user
      end
    end

    def beerxml_files
      params.dig(:recipe, :beerxml).presence || [nil]
    end

    def create_recipes!
      beerxml_files.each_with_object([]) do |beerxml, recipes|
        ActiveRecord::Base.transaction do
          begin
            recipes << import_beerxml(new_recipe, beerxml)
          rescue ActiveRecord::RecordInvalid => e
            Rails.logger.error { "Failed creating recipe: #{e.record.errors.full_messages}" }
          end
        end
      end
    end
end
