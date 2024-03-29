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

  def search_keys
    %i(q style ogfrom ogto fgfrom fgto ibufrom ibuto
      colorfrom colorto abvfrom abvto sort_order equipment
      event_id medal incomplete private has_medal)
  end

  def search_params
    params.permit(*search_keys)
  end

  def honeypot
    begin
      @honeypot ||= ProjectHoneypot::Base.new.lookup(request.remote_ip)
    rescue Net::DNS::Resolver::NoResponseError => e
      ProjectHoneypot::Url.new(request.remote_ip, nil)
    end
  end

  def spammer?
    !honeypot.safe?
  end

  def redirect_guest_spammers!
    Rails.logger.debug { "redirect_guest_spammers! user_signed_in? #{user_signed_in?}" }
    redirect_spammers! unless user_signed_in?
  end

  def redirect_spammers!
    flash[:alert] = I18n.t(:'common.spammer_detected')
    redirect_to root_path
  end

  def deny_spammers!
    if spammer?
      Rails.logger.debug { "Spammer detected by honeypot! IP: #{honeypot.ip_address} Score: #{honeypot.score} Offenses: #{honeypot.offenses} Last activity: #{honeypot.last_activity}" }
      redirect_spammers!
    end
  end

  def load_and_authorize_event_by_id!
    @event = Event.find(params[:id])
    authorize_modify!(@event)
  end

  def load_and_authorize_show_recipe!
    @recipe = Recipe.unscoped.find(params[:id])
    authorize_show!(@recipe)
  end

  def load_and_authorize_recipe_by_id!
    @recipe = Recipe.for_user(current_user).where(id: params[:id]).first!
    authorize_modify!(@recipe)
  end

  def load_and_authorize_recipe!(ingredient = nil)
    scope = if ingredient.nil?
      Recipe.unscoped.with_all_details
    elsif ingredient == :none
      Recipe.unscoped
    else
      Recipe.unscoped.with_details(ingredient)
    end
    @recipe = scope.where(id: params[:recipe_id]).first!
    authorize_modify!(@recipe)
    @details = @recipe.detail
  end

  def authorize_show!(model)
    raise AuthorizationException unless can_show?(model)
  end

  def authorize_modify!(model)
    raise AuthorizationException unless can_modify?(model)
  end

  def can_show?(resource)
    resource.public? || user_signed_in? && current_user.can_show?(resource)
  end

  def can_modify?(resource)
    user_signed_in? && current_user.can_modify?(resource)
  end
end
