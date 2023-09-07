class Book < ApplicationRecord
  # has_one_attached :image
  belongs_to :user
  has_many :favorites, dependent: :destroy
  has_many :favorited_users, through: :favorites, source: :user
  has_many :post_comments, dependent: :destroy
  has_many :read_counts, dependent: :destroy

  validates :title, presence: true
  validates :body, presence: true, length: { maximum: 200 }

  def favorited_by?(user)
    favorites.exists?(user_id: user.id)
  end

  def self.search_for(keyword, method)
    if method == 'perfect'
      Book.where(title: keyword)
    elsif method == 'forward'
      Book.where('title LIKE ?', keyword + '%')
    elsif method == 'backward'
      Book.where('title LIKE ?', '%' + keyword)
    else
      Book.where('title LIKE ?', '%' + keyword + '%')
    end
  end

end
