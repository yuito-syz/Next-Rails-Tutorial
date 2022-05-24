json.set! :post do
    json.extract! @post, :id, :content, :user_id, :created_at
    json.image_url rails_blob_url(@post.image) if @post.image.attached?
    json.liked @post.likes.count
end
json.set! :user do
    json.extract! @user, :name, :id
    json.gravator_url @gravator_url
end
  