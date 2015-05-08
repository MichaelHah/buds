class PhotosController < ApplicationController
  before_action :authenticate_user!, only: [:show, :create, :destroy]
  before_action :correct_user,   only: :destroy


  def show
    @photo = Photo.find(params[:id])
    @comment = Comment.new
    @like = Like.new
    @comments = @photo.comments.paginate(page: params[:page])
  end
  
  def create
    @photo = current_user.photos.build(photo_params)
    if @photo.save
      flash[:success] = "Photo created!"
      redirect_to root_url
    else
      @feed_items = []
      render 'static_pages/home'
    end
  end

  def destroy
    @photo.destroy
    flash[:success] = "Photo deleted"
    redirect_to request.referrer || root_url
  end

  private

    def photo_params
      params.require(:photo).permit(:title, :image)
    end

     def correct_user
      @photo = current_user.photos.find_by(id: params[:id])
      redirect_to root_url if @photo.nil?
    end
end