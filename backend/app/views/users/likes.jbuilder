json.posts do
    json.array! @liked_posts do |post|
      json.extract! post, :id, :content, :user_id, :created_at
      json.image_url rails_blob_url(post.image) if post.image.attached?
      gravator_id = Digest::MD5::hexdigest(post.user.email)
      gravator_url = "https://secure.gravatar.com/avatar/#{gravator_id}"
      json.gravator_url gravator_url
      json.name post.user.name
    end
end