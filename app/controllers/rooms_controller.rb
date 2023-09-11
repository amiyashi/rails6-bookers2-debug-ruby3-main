class RoomsController < ApplicationController
  before_action :authenticate_user!
  # before_action :reject_non_related, only: [:show]

  def create
    @room = Room.create(user_id: current_user.id)
    #Roomは2方向からのEntryを持つから、Entryを2つ作成する
    @entry1 = Entry.create(user_id: current_user.id, room_id: @room.id)
    @entry2 = Entry.create(params.require(:entry).permit(:user_id, :room_id).merge(room_id: @room.id))
    redirect_to room_path(@room)
  end


  def show #チャットルームの画面
    @room = Room.find(params[:id])
    if Entry.where(user_id: current_user.id, room_id: @room.id).present? #present➝要素があるかを確認してくれるメソッド
    　@messages = @room.messages
    　@message = Message.new
    　@entries = @room.entries
    　@myUserId = current_user.id #Roomで相手の名前表示するために記述
    else
      redirect_back(fallback_location: root_path)
    end
  end

  private

    # def reject_non_related #相互フォローしてないユーザーが直接チャットルームのURLからアクセスしても、チャットルームに入れないようにする
    #   room = Room.find(params[:id])
    #   user = room.entries.where.not(user_id: current_user.id).first.user
    #   unless (current_user.following?(user)) && (user.following?(current_user))
    #     redirect_to books_path
    #   end
    # end

end
