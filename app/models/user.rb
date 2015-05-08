class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  #posts
  has_many :posts, dependent: :destroy

  #comments
  has_many :comments, dependent: :destroy

  #friending between users
  has_many :active_friendships,  class_name:  "Friendship",
                                   foreign_key: "friender_id",
                                   dependent:   :destroy
  has_many :passive_friendships, class_name:  "Friendship",
                                   foreign_key: "friended_id",
                                   dependent:   :destroy
  has_many :friending, through: :active_friendships,  source: :friended
  has_many :frienders, through: :passive_friendships, source: :friender

  #friend requests
  has_many :active_friend_requests,  class_name:  "FriendRequest",
                                   foreign_key: "requester_id",
                                   dependent:   :destroy
  has_many :passive_friend_requests, class_name:  "FriendRequest",
                                   foreign_key: "requested_id",
                                   dependent:   :destroy
  has_many :requesting, through: :active_friend_requests,  source: :requested
  has_many :requesters, through: :passive_friend_requests, source: :requester

  #avatar
  mount_uploader :avatar, AvatarUploader
  validate :avatar_size

  #photos
  has_many :photos, dependent: :destroy

  #likes
  has_many :likes, dependent: :destroy

  #notifications
  has_many :notifications, dependent: :destroy

  #nested forms for friending others
  accepts_nested_attributes_for :active_friendships
  accepts_nested_attributes_for :active_friend_requests
  accepts_nested_attributes_for :passive_friend_requests

  # Returns a user's status feed.
  def feed
    friending_ids = "SELECT friended_id FROM friendships
                     WHERE  friender_id = :user_id"
    items = []
    items += Post.where("user_id IN (#{friending_ids}) OR user_id = :user_id", user_id: id) 
    items += Photo.where("user_id IN (#{friending_ids}) OR user_id = :user_id", user_id: id) 
    sorted_items = items.sort_by(&:created_at).reverse
  end

  # Follows a user.
  def friend(other_user)
    active_friendships.create(friended_id: other_user.id)
  end

  # Unfollows a user.
  def unfriend(other_user)
    active_friendships.find_by(friended_id: other_user.id).destroy
  end

  # Returns true if the current user is following the other user.
  def friending?(other_user)
    friending.include?(other_user)
  end

  # Follows a user.
  def friend_request(other_user)
    active_friend_requests.create(requested_id: other_user.id)
  end

  # Unfollows a user.
  def delete_friend_request(other_user)
    passive_friend_requests.find_by(requester_id: other_user.id).destroy
  end

  # Returns true if the current user is following the other user.
  def requesting?(other_user)
    requesting.include?(other_user)
  end

  # Returns true if the current user is following the other user.
  def requesters?(other_user)
    requesters.include?(other_user)
  end

  def notify(message)
    notifications.create(content: message)
  end

  # Likes an object
  def is_liking(object)
    likes.create(likeable_id: object.id, likeable_type: object.class.to_s)
  end

  # Unlikes an object
  def is_not_liking(object)
    likes.find_by(likeable_id: object.id, likeable_type: object.class.to_s).destroy
  end

  def liking?(object)
    likes.find_by(likeable_id: object.id, likeable_type: object.class.to_s)
  end

  private

    # Validates the size of an uploaded picture.
    def avatar_size
      if avatar.size > 5.megabytes
        errors.add(:avatar, "should be less than 5MB")
      end
    end

end