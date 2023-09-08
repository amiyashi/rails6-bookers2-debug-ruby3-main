class MessagesController < ApplicationController
  #showページにアクセスしたときのみfollowing_check
  before_action :following_check, only: [:show]
  
  def show
    @user = User.find(params[:id])
    @message = Message.new
    @messages = Message.where(send_user_id: current_user.id,receive_user_id: params[:id]).or(@receive_messages = Message.where(send_user_id: params[:id],receive_user_id: current_user.id)).order(:created_at)
  end
    
  def create
    @message = Message.new(message_params)
    @message.send_user_id = current_user.id
    if @message.save!
      @messages = Message.where(send_user_id: current_user.id,receive_user_id: params[:message][:receive_user_id]).or(@receive_messages = Message.where(send_user_id: params[:message][:receive_user_id], receive_user_id: current_user.id)).order(:created_at)
    else
      @message = Message.new
      @messages = Message.where(send_user_id: current_user.id,receive_user_id: params[:message][:receive_user_id]).or(@receive_messages = Message.where(send_user_id: params[:message][:receive_user_id], receive_user_id: current_user.id)).order(:created_at)
      render :message
    end
  end

  private
  def message_params
    params.require(:message).permit(:receive_user_id, :message)
  end
  
  def following_check
    user = User.find(params[:id])
    unless current_user.following?(user) && user.following?(current_user)
      redirect_to books_path
    end
  end
  
end
