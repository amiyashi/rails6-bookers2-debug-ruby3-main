class MessagesController < ApplicationController
  
  # def show
  #   @user = User.find(params[:id])
  #   @message = Message.new
  #   @messages = Message.where(send_user_id: current_user.id,receive_user_id: params[:id]).or(@receive_messages = Message.where(send_user_id: params[:id],receive_user_id: current_user.id)).order(:created_at)
  # end
    
  def create
    if Entry.where(user_id => current_user.id, room_id => params[:message][:room_id]).present? #user_idがcurrent_user.idで、room_idがparams[:message]のroom_idであるEntryが存在するなら
      # @message = Message.new(message_params)
      @message = Message.create(params.require(:message).permit(:user_id, :message, :room_id).merge(:user_id => current_user.id))
      # @message.user_id = current_user.id
      # @message.save
      redirect_to "/rooms/#{@message.room_id}"
    else
      redirect_back(fallback_location: root_path)
    end
  end

  # private
  # def message_params
  #   params.require(:message).permit(:user_id, :room_id, :message)
  # end
  
  # def following_check
  #   user = User.find(params[:id])
  #   unless current_user.following?(user) && user.following?(current_user)
  #     redirect_to books_path
  #   end
  # end
  
end
