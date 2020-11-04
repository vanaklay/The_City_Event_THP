class UsersController < ApplicationController
  before_action :authenticate_user!, only: [:show]
  before_action :check_user, only: [:show]

  def show
    @user = current_user
    @events = Event.where(admin: @user).reverse
  end

  def edit
    @user = current_user
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      flash[:notice] = "User updated in DB"
      redirect_to user_path(@user.id)
    else
      flash.now[:alert] = "We cannot updated this gossip for this reason(s) :"
      render :edit
    end
  end

  private
  def user_params
    params.require(:user).permit(:first_name, :last_name, :description)
  end

end
