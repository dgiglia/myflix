class SessionsController < ApplicationController
  def new
    redirect_to home_path if current_user
  end
  
  def create
    user = User.find_by(email: params[:email])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      flash['success'] = "You're signed in."
      redirect_to home_path
    else
      flash['danger'] = "There is something wrong with your email or password."
      redirect_to sign_in_path
    end
  end
  
  def destroy
    session[:user_id] = nil
    flash['success'] = "You're signed out."
    redirect_to root_path
  end
end