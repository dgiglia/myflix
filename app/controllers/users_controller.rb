class UsersController < ApplicationController
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
      flash['success'] = "Profile was successfully created. Please sign in."
      redirect_to sign_in_path
    else
      render :new
    end
  end
  
  private
  def user_params
    params.require(:user).permit(:name, :password, :email)
  end
    
end