class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :post
  belongs_to :commentable, :polymorphic => true
  has_many :likes, :as => :likeable, dependent: :destroy
  validates :user_id, presence: true
  validates :commentable_id, presence: true
  validates :commentable_type, presence: true
  validates :content, presence: true, length: { maximum: 300 }

end
