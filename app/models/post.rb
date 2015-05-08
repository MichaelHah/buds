class Post < ActiveRecord::Base
  belongs_to :user
  has_many :comments, :as => :commentable, dependent: :destroy
  has_many :likes, :as => :likeable, dependent: :destroy
  default_scope -> { order(created_at: :desc) }
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 300 }

end