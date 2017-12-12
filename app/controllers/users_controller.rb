class UsersController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index, :show]

  def index
    @brewers, @users = User.confirmed
      .has_recipes
      .search(params[:user_search])
      .ordered
      .partition { |user| user.recipes_count > 0 }

    @user_search = params[:user_search]

    respond_to do |format|
      format.html { render :index }
      format.json { render layout: false }
    end
  end

  def show
    @user = User.find(params[:id])
    @recipes = @recipes.by_user(@user) if @recipes.present?

    respond_to do |format|
      format.html { render :show }
      format.json { render layout: false }
    end
  end
end
