class FriendRequestsController < ApplicationController
  before_action :authenticate_user!

  def create
    user = User.find(params[:requested_id])
    current_user.friend_request(user)
    user.notify("#{current_user.email} has requested a friendship with you.")
    redirect_to request.referrer || root_url
  end

  def destroy
    user = FriendRequest.find(params[:id]).requester
    current_user.delete_friend_request(user)
    user.notify("#{current_user.email} has declined your request for friendship.")
    redirect_to request.referrer || root_url
  end
end