class LatestItemsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index]

  def index
    @latest = latest_items
  end

  private

  def latest_items
    (User.latest + Recipe.latest + latest_comments).sort_by(&:created_at).reverse
  end

  def latest_comments
    Commontator::Comment.limit(10).order('created_at desc')
  end
end
