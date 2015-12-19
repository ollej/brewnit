class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :authenticate_user!
  before_action :load_recipes

  def after_sign_in_path_for(resource)
    recipes_path
  end

  def after_sign_out_path_for(resource)
    recipes_path
  end

  private
  def load_recipes
    if user_signed_in?
      @recipes = Recipe.for_user(current_user)
    else
      @recipes = Recipe.all
    end
  end
end
