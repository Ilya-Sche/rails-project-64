# frozen_string_literal: true

class PostsController < ApplicationController
  after_action :authorize_post, only: %i[edit update destroy]

  def index
    @posts = Post.includes(:creator).order(created_at: :desc).all
  end

  def show
    @post = set_post
    @comments = @post.comments.includes(:user).arrange

    return unless user_signed_in?

    @liked_by_current_user = @post.likes.exists?(user_id: current_user.id)
    @comment = PostComment.new
  end

  def new
    authenticate_user!
    @post = current_user.posts.build
    @categories = Category.all
  end

  def edit
    @post = set_post
  end

  def create
    authenticate_user!
    @post = current_user.posts.build(post_params)
    if @post.save
      redirect_to @post, notice: I18n.t('flash.create', model: @post.class.name)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    @post = set_post
    if @post.update(post_params)
      redirect_to @post, notice: I18n.t('flash.update', model: @post.class.name)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @post = set_post
    @post.destroy
    redirect_to posts_url, notice: I18n.t('flash.destroy', model: @post.class.name)
  end

  private

  def set_post
    @post = Post.find(params[:id])
  end

  def authorize_post
    return if @post.creator_id == current_user.id

    redirect_to posts_url
  end

  def post_params
    params.require(:post).permit(:title, :body, :category_id)
  end
end
