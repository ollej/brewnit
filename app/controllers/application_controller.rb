class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :authenticate_user!
  before_action :clear_search
  before_action :load_recipes

  def after_sign_in_path_for(resource)
    recipes_path
  end

  def after_sign_out_path_for(resource)
    recipes_path
  end

  private
  def load_recipes
    scope = if user_signed_in?
      Recipe.for_user(current_user)
    else
      Recipe.all
    end
    @recipes = FilterRecipes.new(scope, query_hash).resolve.ordered
  end

  def query_hash
    session[:search] = search_hash.merge(FilterRecipes.parse_params(params))
  end

  def search_hash
    session.fetch(:search, {}).symbolize_keys
  end

  def clear_search
    session.delete(:search) if params[:clear_search].present?
  end

  def can_show?(resource)
    resource.public? || user_signed_in? && current_user.can_show?(resource)
  end
end
