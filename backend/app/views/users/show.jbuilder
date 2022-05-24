json.extract! @user, :id, :name, :email,:created_at
json.gravator_url @gravator_url
json.following_count @following_count
json.followers_count @followers_count
json.posts do
  json.array! @posts do |post|
    json.extract! post, :id, :content, :user_id,:created_at,:updated_at
    json.image_url rails_blob_url(post.image) if post.image.attached?
  end
end