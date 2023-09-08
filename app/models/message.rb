class Message < ApplicationRecord
  belongs_to :send_user, class_name: 'User'
  belongs_to :receive_user, class_name: 'User'
  #空の投稿と文字数制限
  validates :message, presence: true, length: { maximum: 140 }
end