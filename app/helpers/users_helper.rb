module UsersHelper
  def check_user
    @user = User.find(params[:id])
    unless current_user.id == @user.id
       redirect_to root_path
    end
  end

end
