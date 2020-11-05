class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :check_user

  def show
    @user = current_user
    @events = Event.where(admin: @user)
  end

  def edit
    @user = current_user
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to user_path(@user.id), success: "User updated in DB"
    else
      flash.now[:alert] = "We cannot updated this user for this reason(s) :"
      render :edit
    end
  end

  private
  def user_params
    params.require(:user).permit(:first_name, :last_name, :description, :avatar)
  end


end
