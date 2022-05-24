json.user do
    json.extract! @current_user, :id, :name, :email,:created_at,:activated,:activated_at
    json.gravator_url @gravator_url
    # ここからpost情報
    json.posts do
      json.array! @current_posts do |post|
        json.extract! post, :id, :content, :user_id,:created_at,:updated_at
        json.image_url rails_blob_url(post.image) if post.image.attached?
      end
    end
end