class StaticPagesController < ApplicationController
	before_action :authenticate_user!, except: [:about]
	
  def home
    @post = current_user.posts.build if signed_in?
    @photo = current_user.photos.build if signed_in?
    @like = Like.new
    @feed_items = current_user.feed.paginate(page: params[:page])
  end

  def about
  end
end
