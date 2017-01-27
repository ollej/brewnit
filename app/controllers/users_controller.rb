class UsersController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index, :show]

  def index
    @users = User.confirmed.ordered

    respond_to do |format|
      format.html { render :index }
      format.json { render layout: false }
    end
  end

  def show
    @user = User.find(params[:id])
    @recipes = @recipes.by_user(@user)

    respond_to do |format|
      format.html { render :show }
      format.json { render layout: false }
    end
  end
end
