# frozen_string_literal: true

class CommentsController < ApplicationController
  def create
    authenticate_user!
    @post = Post.find(params[:post_id])
    @comment = @post.comments.build(comment_params)
    @comment.user = current_user

    if params[:parent_id].present?
      @parent_comment = @post.comments.find(params[:parent_id])
      @comment.parent = @parent_comment
    end
    if @comment.save
      redirect_to post_path(@post), notice: I18n.t('comment.save')
    else
      redirect_to post_path(@post), alert: I18n.t('comment.failed')
    end
  end

  private

  def comment_params
    params.require(:post_comment).permit(:content, :parent_id)
  end
end
