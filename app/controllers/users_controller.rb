class UsersController < ApplicationController
  before_action :require_user, only: [:show]
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(user_params)
    if @user.valid?                 
      charge = StripeWrapper::Charge.create(
        amount: 999,
        card: params[:stripeToken],
        description: "MyFlix Sign Up Charge for #{@user.email}"
      )
      if charge.successful?
        @user.save     
        handle_invitation
        AppMailer.delay.send_welcome_email(@user)
        flash['success'] = "Profile was successfully created. Please sign in."
        redirect_to sign_in_path
      else
        flash.now['danger'] = charge.error_message
        render :new
      end
    else
      render :new
    end
  end
  
  def show
    @user = User.find(params[:id])
  end
  
  def new_with_invitation_token
    invitation = Invitation.find_by(token: params[:token])
    if invitation
      @user = User.new(email: invitation.recipient_email)
      @invitation_token = invitation.token
      render :new
    else
      redirect_to expired_token_path
    end
  end
  
  private
  def user_params
    params.require(:user).permit(:name, :password, :email)
  end
  
  def handle_invitation
    if params[:invitation_token].present?
      invitation = Invitation.find_by(token: params[:invitation_token])
      @user.follow(invitation.inviter)
      invitation.inviter.follow(@user)
      invitation.update_column(:token, nil)
    end
  end    
end