json.relationships do
  # following情報
  json.following do
    json.array! @following do |user|
      json.extract! user, :id, :name
      gravator_id = Digest::MD5::hexdigest(user.email)
      gravator_url = "https://secure.gravatar.com/avatar/#{gravator_id}"
      json.gravator_url gravator_url
    end
  end
  #followers情報
  json.followers do
      json.array! @followers do |user|
        json.extract! user, :id, :name
        gravator_id = Digest::MD5::hexdigest(user.email)
        gravator_url = "https://secure.gravatar.com/avatar/#{gravator_id}"
        json.gravator_url gravator_url
      end
  end
end
json.following_index @following_index
json.followers_index @followers_index