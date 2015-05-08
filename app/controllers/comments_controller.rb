class CommentsController < ApplicationController
	before_action :authenticate_user!, only: [:create, :destroy]
  before_action :correct_user,   only: :destroy

	def create
    @comment = Comment.new(comment_params)
    @comment.commentable_id = params[:commentable_id]
    @comment.commentable_type = params[:commentable_type]
    @comment.user_id = params[:user_id]
	  @comment.save
    if @comment.save
      flash[:success] = "Comment created"
	    redirect_to request.referrer || root_url
    else
      flash[:warning] = "Can't do that!"
      redirect_to request.referrer || root_url
    end
  end

  def destroy
    @comment.destroy
    flash[:success] = "Comment deleted"
    redirect_to request.referrer || root_url
  end

  private

    def comment_params
      params.require(:comment).permit(:content)
    end

     def correct_user
      @comment = current_user.comments.find_by(id: params[:id])
      redirect_to root_url if @post.nil?
    end
end