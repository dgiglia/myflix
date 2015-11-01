class ForgotPasswordsController < ApplicationController  
  def create
    user = User.find_by(email: params[:email])
    if user
      AppMailer.delay.send_forgot_password(user)
      redirect_to forgot_password_confirmation_path
    else      
      flash['danger'] = "Something is wrong with the email you entered."
      redirect_to forgot_password_path
    end
  end
end