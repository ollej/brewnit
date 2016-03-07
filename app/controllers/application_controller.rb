class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :authenticate_user!
  before_action :clear_search
  before_action :populate_search
  before_action :load_recipes
  before_action :filter_recipes

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

  def load_recipes
    @recipes = if user_signed_in?
      Recipe.for_user(current_user)
    else
      Recipe.all
    end
  end

  def filter_recipes
    @recipes = FilterRecipes.new(@recipes, query_hash).resolve.limit(limit_items)
  end

  def limit_items
    params.fetch(:limit, 50).to_i
  end

  def populate_search
    @search = search_hash
    @sort_fields = FilterRecipes::SORT_FIELDS
  end

  def query_hash
    session[:search] = search_hash
  end

  def search_hash
    Rails.logger.debug { "search_params #{search_params}" }
    session.fetch(:search, {}).merge(search_params).deep_symbolize_keys
  end

  def clear_search
    session.delete(:search) if params[:clear_search].present?
  end

  def can_show?(resource)
    resource.public? || user_signed_in? && current_user.can_show?(resource)
  end

  def search_params
    params.permit(:q, :style, :ogfrom, :ogto, :fgfrom, :fgto, :ibufrom, :ibuto,
                  :colorfrom, :colorto, :abvfrom, :abvto, :sort_order, :equipment)
  end

  def honeypot
    @honeypot ||= ProjectHoneypot.lookup(request.remote_ip)
  end

  def spammer?
    honeypot.suspicious?
  end

  def redirect_spammers!
    Rails.logger.debug { "Spammer detected! #{request.remote_ip}" }
    flash[:alert] = I18n.t(:'common.spammer_detected')
    redirect_to root_path
  end

  def deny_spammers!
    redirect_spammers! if spammer?
  end
end
