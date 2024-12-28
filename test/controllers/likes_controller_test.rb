# frozen_string_literal: true

require 'test_helper'

class LikesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @post = posts(:one)
    @user = users(:one)
    @second_user = users(:two)
    @likes = []
  end

  test 'should add like to post' do
    sign_in @second_user

    @likes << @post.likes.create(user: @second_user)

    assert_difference('@post.likes.count', 1) do
      post post_likes_url(@post)
    end

    assert_redirected_to @post
  end

  test 'should remove like from post' do
    sign_in @user

     @likes <<  @post.likes.create(user: @user)

    assert_difference('@post.likes_count', -1) do
      delete post_like_url(@post, @user)
    end

    assert_redirected_to @post
  end
end
