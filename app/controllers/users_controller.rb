class UsersController < ApplicationController
  before_action :authenticate_user!, only: [:show, :index, :friending, :frienders, :requesting, :requesters]

  def show
    @user = User.find(params[:id])
    @posts = @user.posts.paginate(page: params[:page])
    @like = Like.new
    @photos = @user.photos.paginate(page: params[:page])
  end

  def index
    @users = User.paginate(page: params[:page])
  end

 def friending
    @title = "Friends"
    @user  = User.find(params[:id])
    @users = @user.friending.paginate(page: params[:page])
    render 'show_friend'
  end

  def frienders
    @title = "Friends"
    @user  = User.find(params[:id])
    @users = @user.frienders.paginate(page: params[:page])
    render 'show_friend'
  end

 def requesting
    @title = "Pending Friend Requests"
    @user  = User.find(params[:id])
    @users = @user.requesting.paginate(page: params[:page])
    render 'show_friend_requests'
  end

  def requesters
    @title = "Friend Requests"
    @user  = User.find(params[:id])
    @users = @user.requesters.paginate(page: params[:page])
    render 'show_friend_requests'
  end


end
