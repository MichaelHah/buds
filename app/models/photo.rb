class Photo < ActiveRecord::Base
  belongs_to :user
  has_many :comments, :as => :commentable, dependent: :destroy
  has_many :likes, :as => :likeable, dependent: :destroy
  default_scope -> { order(created_at: :desc) }
  mount_uploader :image, PhotoUploader
  validate :image_size
  validates :image, presence: true
  validates :user_id, presence: true
  validates :title, length: { maximum: 70}

  private

    # Validates the size of an uploaded picture.
    def image_size
      if image.size > 10.megabytes
        errors.add(:image, "should be less than 10MB")
      end
    end

end
