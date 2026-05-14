module DirtyConcern
  extend ActiveSupport::Concern

  included do
    after_commit :set_dirty_on_detail
  end

  def set_dirty_on_detail
    recipe_detail.update(dirty: true)
  end
end
