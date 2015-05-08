class LikesController < ApplicationController
  before_action :authenticate_user!

  def create
    @like = Like.new
    @like.likeable_id = params[:likeable_id]
    @like.likeable_type = params[:likeable_type]
    @like.user_id = params[:user_id]
    @like.save
    if @like.save
      flash[:success] = "Like approved!"
	  redirect_to request.referrer || root_url
    else
      flash[:warning] = "Unable to do that!"
      redirect_to request.referrer || root_url
    end
  end

end
