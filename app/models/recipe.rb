class Recipe < ActiveRecord::Base
  belongs_to :user

  default_scope { where(public: true) }
  scope :for_user, -> (user) { unscoped.where('user_id = ? OR public = true', user.id) }
end
