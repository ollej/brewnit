class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception, unless: -> { request.format.json? }
  before_action :authenticate_user!
  before_action :clear_search
  before_action :populate_search
  before_action :load_filtered_recipes

  def after_sign_in_path_for(resource)
    after_sign_in_path = stored_location_for(resource) || root_path
    Rails.logger.debug { "stored_location_for resource: #{stored_location_for(resource)}" }
    Rails.logger.debug { "after_sign_in_path: #{after_sign_in_path}" }
    after_sign_in_path
  end

  def after_sign_out_path_for(resource)
    root_path
  end

  private

  def scoped_recipes
    if user_signed_in?
      Recipe.for_user(current_user)
    else
      Recipe.completed
    end
  end

  def filter_recipes
    @filter_recipes ||= FilterRecipes.new(scoped_recipes, query_hash)
  end

  def load_filtered_recipes
    @recipes = filter_recipes.resolved
      .joins(:user).includes(:user)
      .includes(:media)
      .includes(:placements)
      .limit(limit_items)
  end

  def limit_items
    params.fetch(:limit, FilterRecipes::PAGE_LIMIT).to_i
  end

  def populate_search
    @search = search_hash
    @sort_fields = FilterRecipes::SORT_FIELDS
  end

  def query_hash
    session[:search] = search_hash
  end

  helper_method :search_hash
  def search_hash
    Rails.logger.debug { "search_params #{search_params}" }
    @search_hash ||= session.fetch(:search, {}).merge(search_params).deep_symbolize_keys
  end

  def clear_search
    session.delete(:search) if params[:clear_search].present?
  end

  def can_show?(resource)
    resource.public? || user_signed_in? && current_user.can_show?(resource)
  end

  def search_keys
    %i(q style ogfrom ogto fgfrom fgto ibufrom ibuto
      colorfrom colorto abvfrom abvto sort_order equipment
      event_id medal incomplete private has_medal)
  end

  def search_params
    params.permit(*search_keys)
  end

  def honeypot
    @honeypot ||= ProjectHoneypot.lookup(request.remote_ip)
  end

  def spammer?
    !honeypot.safe?
  end

  def redirect_spammers!
    Rails.logger.debug { "Spammer detected! IP: #{honeypot.ip_address} Score: #{honeypot.score} Offenses: #{honeypot.offenses} Last activity: #{honeypot.last_activity}" }
    flash[:alert] = I18n.t(:'common.spammer_detected')
    redirect_to root_path
  end

  def deny_spammers!
    redirect_spammers! if spammer?
  end

  def load_and_authorize_recipe(ingredient = nil)
    scope = if ingredient.nil?
      Recipe.unscoped.with_all_details
    else
      Recipe.unscoped.with_details(ingredient)
    end
    @recipe = scope.where(id: params[:recipe_id]).first!
    raise AuthorizationException unless current_user.can_modify?(@recipe)
    @details = @recipe.detail
  end
end
