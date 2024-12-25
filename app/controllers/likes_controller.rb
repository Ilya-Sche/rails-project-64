# frozen_string_literal: true

class LikesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post

  def create
    unless @post.likes.exists?(user: current_user)
      @like = @post.likes.new(user: current_user)
      @like.save
    end
    redirect_to @post
  end

  def destroy
    @like = @post.likes.find_by(user: current_user)

    @like&.destroy
    redirect_to @post
  end

  private

  def set_post
    @post = Post.find(params[:post_id])
  end
end
