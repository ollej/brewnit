json.extract! @user, :id, :name, :created_at, :updated_at, :presentation,
  :location, :brewery, :twitter, :equipment
json.homepage @user.url
json.url user_url(@user)
json.avatar @user.avatar_image

