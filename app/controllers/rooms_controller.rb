class RoomsController < ApplicationController
  before_action :authenticate_user!
  
  def show
    @user = User.find(params[:id])
    rooms = current_user.user_rooms.pluck(:room_id)
    user_rooms = UserRoom.find_by(user_id: @user.id, room_id: rooms)
    
    unless user_rooms.nil?
      @room = user_rooms.room
    else
      @room = Room.new
      @room.save
      UserRoom.create(user_id: current_user.id, room_id: @room.id)
      UserRoom.create(user_id: @user.id, room_id: @room.id)
    end
    @messages = @room.messages
    @message = Message.new(room_id: @room.id)
  end
  
  def create
    @message = current_user.messages.new(message_params)
    @room = Room.create(user_id: current_user.id)
    @currentUserEntry = Entry.create(user_id: current_user.id, room_id: @room.id)
    @anotherUserEntry = Entry.create(params.require(:entry).permit(:user_id, :room_id).merge(:room_id => @room.id))
    redirect_to room_path(@room)
  end
   
  
end
