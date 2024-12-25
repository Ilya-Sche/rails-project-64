# frozen_string_literal: true

require 'test_helper'

class CategoriesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @category = categories(:one)
  end

  test 'should get index' do
    get categories_url
    assert_response :success
  end

  test 'should get new' do
    get new_category_url
    assert_response :success
  end

  test 'should create category' do
    attrs = { name: Faker::Commerce.department }

    assert_difference('Category.count', 1) do
      post categories_url, params: { category: attrs }
    end

    created_category = Category.find_by(attrs)
    assert_not_nil created_category
    assert_redirected_to category_url(created_category)
  end

  test 'should show category' do
    get category_url(@category)
    assert_response :success
  end
end
