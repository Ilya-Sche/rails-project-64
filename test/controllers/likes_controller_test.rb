# frozen_string_literal: true

require 'test_helper'

class LikesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @post = posts(:one)
    @user = users(:one)
    @second_user = users(:two)
    @like = likes(:one)
    sign_in @user
  end

  test 'should add like to post' do
    @post.likes.create(user: @second_user)

    assert_difference('@post.likes_count', 1) do
      post post_likes_url(@post)
    end

    assert_redirected_to @post
  end

  test 'should remove like from post' do
    @post.likes.create(like: @like, user: @user)

    assert_difference('@post.likes_count', -1) do
      delete post_like_url(@post, @like)
    end

    assert_redirected_to @post
  end
end
