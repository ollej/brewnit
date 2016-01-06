class UsersController < ApplicationController
  def index
    @users = User.all.ordered
  end

  def show
    @user = User.find(params[:id])
    @recipes = @recipes.by_user(@user)

    respond_to do |format|
      format.html { render :show }
      format.json { render json: @user }
    end
  end
end
