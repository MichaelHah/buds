class FriendshipsController < ApplicationController
  before_action :authenticate_user!

  def create
    user = User.find(params[:friended_id])
    current_user.friend(user)
    user.friend(current_user)
    current_user.delete_friend_request(user)
    user.notify("#{current_user.email} has accepted your request to be friends.")
    redirect_to request.referrer || root_url
  end

  def destroy
    user = Friendship.find(params[:id]).friended
    current_user.unfriend(user)
    user.unfriend(current_user)
    user.notify("#{current_user.email} has declined your request to be friends.")
    redirect_to request.referrer || root_url
  end
end