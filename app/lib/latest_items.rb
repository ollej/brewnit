class LatestItems
  def initialize(user)
    @user = user
  end

  def all
    (User.latest + Recipe.latest + Event.latest + latest_comments).sort_by(&:created_at).reverse
  end

  def latest_comments
    Commontator::Comment.where(deleted_at: nil).limit(10).order('created_at desc').reject do |comment|
      comment.creator.nil? || comment.thread.commontable.nil? || !comment.thread.can_be_read_by?(@user)
    end
  end
end
