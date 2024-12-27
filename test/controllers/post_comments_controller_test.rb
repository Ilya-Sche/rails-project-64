# frozen_string_literal: true

require 'test_helper'

class CommentsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  setup do
    @post = posts(:one)
    @parent_comment = post_comments(:one)
    @user = users(:one)
    sign_in @user
  end

  test 'should create comment' do
    content = Faker::Lorem.sentence

    assert_difference('PostComment.count', 1) do
      post post_comments_url(@post),
           params: { post_comment: { content: content, post_id: @post.id, user_id: @user.id } }
    end

    created_comment = PostComment.find_by(content: content, post_id: @post.id, user_id: @user.id)
    assert_not_nil created_comment
    assert_redirected_to @post
  end

  test 'should reply to comment' do
    assert_difference('PostComment.count', 1) do
      post post_comments_url(@post),
           params: { post_comment: { content: 'This is a reply', post_id: @post.id, user_id: @user.id, parent_id: @parent_comment.id } }
    end
    new_comment = PostComment.find_by(
      content: 'This is a reply',
      post_id: @post.id,
      user_id: @user.id,
      parent_id: @parent_comment.id
    )
  
    assert_equal @parent_comment.id, new_comment.parent_id
    assert_equal @user.id, new_comment.user_id
    assert_equal @post.id, new_comment.post_id
    assert_equal 'This is a reply', new_comment.content
    assert_redirected_to @post
  end
end
