class RecipeMailer < ApplicationMailer
  def new_recipe
    @user = params[:user]
    @recipe = params[:recipe]
    @url = recipe_url(@recipe)
    if @user.receive_email?
      mail(to: @user.email, subject: "Nytt recept på Brygglogg.se: #{@recipe.name}")
    end
  end

  def recipe_cloned
    @user = params[:user]
    @recipe = params[:recipe]
    @clone = params[:clone]
    @recipe_url = recipe_url(@recipe)
    @clone_url = recipe_url(@clone)
    if @user.receive_email?
      mail(to: @user.email, subject: "Ny klon av ditt recept på Brygglogg.se: #{@recipe.name}")
    end
  end
end
