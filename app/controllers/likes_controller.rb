class LikesController < ApplicationController
  def create
    @recipe = Recipe.find(params[:id])
    raise ActiveRecord::RecordNotFound unless can_show?(@recipe)
    @recipe.liked_by current_user

    respond_to do |format|
      if request.xhr?
        format.html { render partial: 'shared/like_button' }
      else
        format.html { redirect_to @recipe, notice: I18n.t(:'recipes.likes.successful') }
      end
      format.json { head status: :created }
    end
  end

  def destroy
    @recipe = Recipe.find(params[:id])
    raise ActiveRecord::RecordNotFound unless can_show?(@recipe)
    raise ActiveRecord::RecordNotFound unless @recipe.owned_by?(current_user)
    @recipe.unliked_by current_user

    respond_to do |format|
      if request.xhr?
        format.html { render partial: 'shared/like_button' }
      else
        format.html { redirect_to @recipe, notice: I18n.t(:'recipes.likes.successful_unlike') }
      end
      format.json { head :accepted }
    end
  end
end
