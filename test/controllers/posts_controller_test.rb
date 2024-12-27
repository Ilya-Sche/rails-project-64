# frozen_string_literal: true

require 'test_helper'

class PostsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  setup do
    @category = categories(:one)
    @post = posts(:one)
    @user = users(:one)
    sign_in @user
  end

  test 'should get index' do
    get posts_url
    assert_response :success
  end

  test 'should get new' do
    get new_post_url
    assert_response :success
  end

  test 'should create post' do
    attrs = { title: Faker::Lorem.sentence, body: Faker::Lorem.paragraph, category_id: @category.id }

    assert_difference('Post.count', 1) do
      post posts_url, params: { post: attrs }
    end

    created_post = Post.find_by(attrs.merge(user_id: @user.id))
    assert_not_nil created_post
    assert_redirected_to post_url(created_post)
  end

  test 'should show post' do
    get post_url(@post)
    assert_response :success
  end

  test 'should get edit' do
    get edit_post_url(@post)
    assert_response :success
  end

  test 'should update post' do
    new_title = Faker::Lorem.sentence
    new_body = Faker::Lorem.paragraph

    patch post_url(@post), params: { post: { title: new_title, body: new_body, category_id: @post.category_id } }

    assert_redirected_to post_url(@post)

    @post.reload
    assert_equal new_title, @post.title
    assert_equal new_body, @post.body
  end

  test 'should destroy post' do
    assert_difference('Post.count', -1) do
      delete post_url(@post)
    end
    assert_nil Post.find_by(id: @post.id)
    assert_redirected_to posts_url
  end
end
