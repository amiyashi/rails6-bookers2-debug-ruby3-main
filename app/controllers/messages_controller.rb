class MessagesController < ApplicationController
  #showページにアクセスしたときのみfollowing_check
  before_action :following_check, only: [:show]
  
  def show
    @user = User.find(params[:id])
    rooms = current_user.entries.pluck(:room_id) #自分のuser_idと一致するentriesのroom_idを取得
    entries = Entry.find_by(user_id: @user.id, room_id: rooms) #上記に合致するentriesがあるか探す
    if entries.nil? #見つからなかったら
      message_room = Room.new #新しくRoomを作成
      message_room.save
      Entries.create(user_id: current_user.id, room_id: message_room.id)
      Entries.create(user_id: @user.id, room_id: message_room.id)
    else #見つかったら
      message_room = entries.rooms #entriesのroomの情報（room_id）取り出す。roomはuserモデルで記載したrooms
    end
    @messages = @room.messages #room_idに合致するmessageの内容を取得。messagesはuserモデルで記載したmessages
    @message = Message.new(room_id: message_room.id) #空のインスタンスの作成
  end
  
  def create
    @message = current_user.messages.new(message_params)
    @message.save
    redirect_to request.referer
  end

  private
  def message_params
    params.require(:message).permit(:message, :room_id)
  end
  
  private
  
  def following_check
    user = User.find(params[:id])
    unless current_user.following?(user) && user.following?(current_user)
      redirect_to books_path
    end
  end
  
end
