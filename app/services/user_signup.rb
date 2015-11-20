class UserSignup
  attr_reader :error_message
  
  def initialize(user)
    @user = user
  end
  
  def sign_up(stripe_token, invitation_token=nil)
    if @user.valid?                 
      charge = StripeWrapper::Charge.create(
        amount: 999,
        card: stripe_token,
        description: "MyFlix Sign Up Charge for #{@user.email}"
      )
      if charge.successful?
        @user.save     
        handle_invitation(invitation_token)
        AppMailer.delay.send_welcome_email(@user)
        @status = :success
      else
        @status = :fail
        @error_message = charge.error_message
      end
    else
      @status = :fail
      @error_message = "Invalid user information. Please check error messages below."
    end
    self
  end
  
  def successful?
    @status == :success
  end
  
  private
  
  def handle_invitation(invitation_token)
    if invitation_token.present?
      invitation = Invitation.find_by(token: invitation_token)
      @user.follow(invitation.inviter)
      invitation.inviter.follow(@user)
      invitation.remove_token
    end
  end  
end