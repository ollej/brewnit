class RecipesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index, :show]
  before_action :deny_spammers!, only: [:create, :update, :destroy]
  before_action :load_and_authorize_recipe_by_id!, only: [:edit, :update, :destroy]
  before_action :load_and_authorize_show_recipe!, only: [:show]
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
    raise RecipeNotComplete unless @recipe.complete?
    @beerxml = BeerxmlParser.new(@recipe.beerxml).recipe
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
  end

  # POST /recipes
  # POST /recipes.json
  def create
    @recipe = create_recipes

    respond_to do |format|
      if @recipe.present? && @recipe.persisted?
        send_new_recipe_email(@recipe)
        format.html { redirect_to redirect_path, notice: I18n.t(:'recipes.create.successful') }
        format.json { render :show, status: :created }
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
    respond_to do |format|
      if @recipe.update(recipe_params)
        if beerxml_files.present?
          Rails.logger.debug { "RecipesController#update updating recipe with a beerxml file" }
          update_beerxml(recipe: @recipe, beerxml: beerxml_files.read)
          # TODO: Handle errors gracefully
        end
        format.html { redirect_to redirect_path, notice: I18n.t(:'recipes.update.successful') }
        format.json { render :show, status: :ok }
        format.js { render json: @recipe, status: :ok }
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
    @recipe.destroy

    respond_to do |format|
      format.html { redirect_to recipes_url, notice: I18n.t(:'recipes.destroy.successful') }
      format.json { head :no_content }
    end
  end

  private
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

    def import_recipe(recipe: nil, beer_recipe: nil, beerxml: nil)
      recipe ||= new_recipe
      BeerxmlImport.new(recipe, beer_recipe).run
      recipe.beerxml = beerxml || BeerxmlExport.new(recipe).render
      recipe.save!
      recipe
    end

    def new_recipe
      Recipe.new(recipe_params) do |recipe|
        recipe.user = current_user
      end
    end

    def beerxml_files
      params.dig(:recipe, :beerxml)
    end

    def create_recipes
      if beerxml_files.present?
        create_recipes!.last
      else
        recipe = new_recipe
        recipe.save
        recipe
      end
    end

    def create_recipes!
      beerxml_files.each_with_object([]) do |beerxml, recipes|
        ActiveRecord::Base.transaction do
          begin
            parser = BeerxmlParser.new(beerxml.read)
            if parser.many?
              Rails.logger.debug { "RecipesController#create importing multiple recipes in one beerxml file" }
              parser.recipes.each do |beer_recipe|
                recipes << import_recipe(beer_recipe: beer_recipe)
              end
            else
              Rails.logger.debug { "RecipesController#create importing one recipe in a beerxml file" }
              recipes << import_recipe(beer_recipe: parser.recipe, beerxml: parser.beerxml)
            end
          rescue ActiveRecord::RecordInvalid => e
            Rails.logger.error { "Failed creating recipe: #{e.record.errors.full_messages}" }
          end
        end
      end
    end

    def update_beerxml(recipe:, beerxml:)
      parser = BeerxmlParser.new(beerxml)
      if parser.many?
        import_recipe(recipe: recipe, beer_recipe: parser.recipes.first)
      else
        import_recipe(recipe: recipe, beer_recipe: parser.recipe, beerxml: beerxml)
      end
    end

    def send_new_recipe_email(recipe)
      User.where(receive_email: true).each do |user|
        RecipeMailer.with(user: user, recipe: recipe).new_recipe.deliver_later
      end
    end
end
