json.array! @users do |user|
    json.extract! user, :id, :name, :email
    gravator_id = Digest::MD5::hexdigest(user.email)
    gravator_url = "https://secure.gravatar.com/avatar/#{gravator_id}"
    json.gravator_url gravator_url
end