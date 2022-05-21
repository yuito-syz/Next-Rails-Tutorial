class Post < ApplicationRecord
  belongs_to :user
  has_one_attached :image
  has_many :likes, dependent: :destroy
  has_many :liked_users, through: :likes, source: :user

  default_scope -> { order(created_at: :desc) }
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }
end
