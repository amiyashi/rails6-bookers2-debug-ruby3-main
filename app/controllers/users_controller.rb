class UsersController < ApplicationController
  # before_action :authenticate_user!, only: [:show]
  before_action :ensure_correct_user, only: [:update]

  def show
    @user = User.find(params[:id])
    @book = Book.new
    @books = @user.books
    @currentUserEntry = Entry.where(user_id: current_user.id) #現在ログインしているユーザーの全Entryデータを取得
    @userEntry=Entry.where(user_id: @user.id) #DM相手の全Entryデータ取得
    if @user.id == current_user.id #相手と自分(ログインしてる)を区別して、2人のRoomが存在するか確認
    else #現在ログインしているユーザーじゃなかったら
      @currentUserEntry.each do |current| #現在ログインしているユーザーの全Entryデータを1つずつ取り出すす
        @anotherUserEntry.each do |user| #相手の全Entryデータを1つずつ取り出す
          if current.room_id == user.room_id then #自分(ログインしてる)のEntryデータのうち、room_idが相手のEntryデータの持つroom_idと同じとき（2人のRoomが存在するとき）
            @is_room = true #自分(ログインしてる)と相手の共通のRoomがある
            @room_id = current.room_id #自分と相手の共通のroom_idを取り出す
          end
        end
      end
      if @is_room
      else #共通のRoomが無かったら
        @room = Room.new #新しいRoomと
        @entry = Entry.new #新しいEntryを作成
      end
    end
  end

  def index
    @users = User.all
    @book = Book.new
    @user = current_user
    @room = Room.new
  end

  def edit
    @user = User.find(params[:id])
    if @user == current_user
      render :edit
    else
      redirect_to user_path(current_user)
    end
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to user_path(current_user), notice: "You have updated user successfully."
    else
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :introduction, :profile_image)
  end

  def ensure_correct_user
    @user = User.find(params[:id])
    unless @user == current_user
      redirect_to user_path(current_user)
    end
  end
end
