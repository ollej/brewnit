class RecipesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index, :show]
  before_action :set_recipe, only: [:show, :edit, :update, :destroy]
  before_action :authorize!, only: [:edit, :update, :destroy]

  # GET /recipes
  # GET /recipes.json
  def index
    if user_signed_in?
      @recipes = Recipe.for_user(current_user)
    else
      @recipes = Recipe.all
    end
  end

  # GET /recipes/1
  # GET /recipes/1.json
  def show
    if @recipe.public? || user_signed_in? && current_user.can_show?(@recipe)
      respond_to do |format|
        @beerxml = parse_beerxml
        format.html { render :show }
      end
    else
      raise ActiveRecord::RecordNotFound
    end
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
        format.html { redirect_to @recipe, notice: 'Recipe was successfully created.' }
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
        format.html { redirect_to @recipe, notice: 'Recipe was successfully updated.' }
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
      format.html { redirect_to recipes_url, notice: 'Recipe was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_recipe
      @recipe = Recipe.unscoped.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def recipe_params
      recipe = params.require(:recipe).permit(:name, :description, :beerxml, :public)
      recipe[:beerxml] = recipe[:beerxml].read if recipe[:beerxml].present?
      recipe
    end

    def parse_beerxml
      parser = NRB::BeerXML::Parser.new
      xml = StringIO.new(@recipe.beerxml)
      recipe = parser.parse(xml)
      BeerRecipe::RecipeWrapper.new(recipe.records.first)
    end

    def authorize!
      raise ActiveRecord::RecordNotFound unless current_user.can_modify?(@recipe)
    end
end
