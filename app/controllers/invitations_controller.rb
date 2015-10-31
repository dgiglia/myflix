class InvitationsController < ApplicationController
  before_action :require_user
  
  def new
    @invitation = Invitation.new
  end
  
  def create
    @invitation = Invitation.new(invitation_params.merge!(inviter_id: current_user.id))
    if @invitation.save
      AppMailer.send_invitation_email(@invitation).deliver
      flash['success'] = "An invitation has been sent to #{@invitation.recipient_name}."
      redirect_to new_invitation_path
    else
      flash['danger'] = "Your invitation was not sent."
      render :new
    end
  end
  
  private
  def invitation_params
    params.require(:invitation).permit(:recipient_name, :recipient_email, :message, :inviter_id, :token)
  end
end