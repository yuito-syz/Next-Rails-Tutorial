json.user do
    json.extract! @user, :id, :name
    json.gravator_url @gravator_url
end
json.following do
    json.array! @following do |user|
      json.extract! user, :id, :name
      gravator_id = Digest::MD5::hexdigest(user.email)
      gravator_url = "https://secure.gravatar.com/avatar/#{gravator_id}"
      json.gravator_url gravator_url
    end
end