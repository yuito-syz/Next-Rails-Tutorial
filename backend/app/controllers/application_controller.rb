class ApplicationController < ActionController::API
    def gravator_for(user)
        gravator_id = Digest::MD5::hexdigest(user.email)
        gravator_url = "https://secure.gravatar.com/avatar/#{gravator_id}"
        gravator_url
    end

    #JWTでuserIDをtoken化させる
    def encode_token(payload)
        JWT.encode(payload,'s3cr3t')
    end

    def auth_header
        #{Authorization: 'Bearer <token>'}
        request.headers['Authorization']
    end

    def decoded_token
    if auth_header
        token = auth_header.split(' ')[1]
        #Header: {Authorization: 'Bearer <token>'}
        begin
            JWT.decode(token, 's3cr3t', true, algorothm: 'HS256')
        rescue JWT::DecodeError
            nil
        end
    end
    end

    def logged_in_user
        if decoded_token
            user_id = decoded_token[0]['user_id']
            @current_user = User.find(user_id)
        end
    end

    def logged_in?
        !!logged_in_user
    end
    #current_userがなければ、errorを発生
    def authorized
        render json: { message: 'Please log in'}, status: :unauthorized unless logged_in?
    end

    #渡されたuserがcurrent_userか確認
    def current_user?(user)
        user && user == @current_user
    end

    #current_userとuserが等しくないと、errorを発生
    def correct_user
        render json: { message: 'You are not correct user'}, status: :forbidden unless !!current_user?(@user) || is_admin?(@current_user)
    end

    def is_admin?(user)
        user.admin?
    end

    # 有効化されていればtrueを返す
    def is_activated?(user)
        user.activated?
    end

    #　@current_userが有効化されていなければ、errorが発生
    def activated_current_user
        render json: { message: 'Your account is not activated.  Please check your email.'}, status: :unauthorized unless is_activated?(@current_user)
    end
end
