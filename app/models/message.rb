class Message < ApplicationRecord
  belongs_to :user
  belongs_to :room
  #空の投稿と文字数制限
  validates :message, presence: true, length: { maximum: 140 }
end