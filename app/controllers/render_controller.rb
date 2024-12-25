# frozen_string_literal: true

class RenderController < ApplicationController
  def index
    @categories = Category.includes(:posts).all
  end
end
