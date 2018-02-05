class DownloadUserAvatars < ActiveRecord::Migration[5.1]
  def up
    User.where.not(avatar: [nil, '']).each do |user|
      begin
        user.create_medium(user.avatar, :avatar)
      rescue StandardError => e
        Rails.logger.error { "Error importing avatar User<#{user.id}> Avatar URL: '#{user.avatar}' Error: #{e.to_s}" }
      end
    end
  end
end
