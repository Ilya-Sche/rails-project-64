# frozen_string_literal: true

class PostsController < ApplicationController
  before_action :authenticate_user!, unless: :devise_controller?, only: %i[edit update destroy]
  before_action :set_post, only: %i[show edit update destroy]
  before_action :authorize_post, only: %i[edit update destroy]

  def index
    @posts = Post.includes(:category, :creator).all
  end

  def show
    @post = Post.find(params[:id])
  end

  def new
    @post = Post.new(creator_id: current_user.id)
    @categories = Category.all
  end

  def edit
    @post = Post.find(params[:id])
  end

  def create
    @post = Post.new(post_params.merge(creator_id: current_user.id))

    respond_to do |format|
      if @post.save
        format.html { redirect_to @post, notice: I18n.t('flash.create', model: @post.class.name) }
        format.json { render :show, status: :created, location: @post }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to @post, notice: I18n.t('flash.update', model: @post.class.name) }
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @post.destroy
    respond_to do |format|
      format.html { redirect_to posts_url, notice: I18n.t('flash.destroy', model: @post.class.name) }
      format.turbo_stream { render turbo_stream: turbo_stream.remove(@post) }
    end
  end

  private

  def set_post
    @post = Post.find(params[:id])
  end

  def authorize_post
    return if @post.creator == current_user

    redirect_to posts_url
  end

  def post_params
    params.require(:post).permit(:title, :body, :creator_id, :category_id)
  end
end
