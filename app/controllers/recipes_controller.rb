class RecipesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index, :show]
  before_action :set_recipe, only: [:show, :edit, :update, :destroy]
  before_action :authorize!, only: [:edit, :update, :destroy]

  # GET /recipes
  # GET /recipes.json
  def index
  end

  # GET /recipes/1
  # GET /recipes/1.json
  def show
    raise ActiveRecord::RecordNotFound unless can_show(@recipe)
    @beerxml = @recipe.beerxml_details
    commontator_thread_show(@recipe)
    respond_to do |format|
      format.html { render :show }
      format.json { render json: @recipe }
      format.xml {
        send_data @recipe.beerxml, {
          type: 'application/xml',
          disposition: 'attachment',
          filename: "#{@recipe.name}.xml"
        }
      }
    end
  end

  def download
    raise ActiveRecord::RecordNotFound unless can_show(@recipe)
    send_data @recipe.beerxml, type: 'application/xml', disposition: 'attachment'
  end

  # GET /recipes/new
  def new
    @recipe = Recipe.new
  end

  # GET /recipes/1/edit
  def edit
  end

  # POST /recipes
  # POST /recipes.json
  def create
    @recipe = Recipe.new(recipe_params)
    @recipe.user = current_user

    respond_to do |format|
      if @recipe.save
        format.html { redirect_to @recipe, notice: I18n.t(:'recipes.create.successful') }
        format.json { render :show, status: :created, location: @recipe }
      else
        format.html { render :new }
        format.json { render json: @recipe.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /recipes/1
  # PATCH/PUT /recipes/1.json
  def update
    respond_to do |format|
      if @recipe.update(recipe_params)
        format.html { redirect_to @recipe, notice: I18n.t(:'recipes.update.successful') }
        format.json { render :show, status: :ok, location: @recipe }
      else
        format.html { render :edit }
        format.json { render json: @recipe.errors, status: :unprocessable_entity }
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
    def set_recipe
      @recipe = Recipe.unscoped.find(params[:id])
    end

    def recipe_params
      recipe = params.require(:recipe).permit(:name, :description, :beerxml, :public)
      recipe[:beerxml] = recipe[:beerxml].read if recipe[:beerxml].present?
      recipe
    end

    def authorize!
      raise ActiveRecord::RecordNotFound unless current_user.can_modify?(@recipe)
    end

    def can_show(resource)
      resource.public? || user_signed_in? && current_user.can_show?(resource)
    end
end
