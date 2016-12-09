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
    Commontator::Comment.where(deleted_at: nil).limit(10).order('created_at desc').reject do |comment|
      comment.thread.commontable.nil? || !comment.thread.can_be_read_by?(current_user)
    end
  end
end
