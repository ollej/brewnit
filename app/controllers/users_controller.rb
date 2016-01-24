class UsersController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index, :show]

  def index
    @users = User.all.ordered

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

  def media_avatar
    @user = User.find(params[:id])
    raise ActiveRecord::RecordNotFound unless current_user.can_modify?(@user)
    @medium = @user.media.find(params[:medium])
    @user.media_avatar = @medium
    @user.save

    respond_to do |format|
      format.html { redirect_to @user }
      format.json { head :no_content }
    end
  end
end
