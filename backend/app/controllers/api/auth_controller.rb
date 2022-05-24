module Api
    class AuthController < ApplicationController
      before_action :authorized, except: [:login]
  
      def login
        @user = User.find_by(email: params[:email])
        if @user && @user.authenticate(params[:password])
          payload = { user_id: @user.id }
          token = encode_token(payload)
  
          render json: { user: { email: @user.email, id: @user.id, name: @user.name, gravator_url: gravator_for(@user) }, token: token }
        else
          render json: { error: "Invalid username or password" }, status: :unauthorized
        end
      end
  
      # get '/auto_login',
      def auto_login
        @gravator_url = gravator_for(@current_user)
        @current_posts = @current_user.posts.with_attached_image
        render "users/auto_login", formats: :json, handlers: "jbuilder"
      end
  
      # get '/auto_relationships',
      # relationship情報を取得する
      def auto_relationships
        @following = @current_user.following
        @followers = @current_user.followers
        # @following_index = @following.pluck("id")
        @following_index = @following.ids
        @followers_index = @followers.ids
  
        render "users/auto_relationships", formats: :json, handlers: "jbuilder"
        # render json:{following: @following, followers: @followers,user: @current_user}
      end
  
      # feed内のpostの情報を取得する
      def auto_feed
        @Offset = params[:Offset] ? params[:Offset].to_i : 0
        @Limit = params[:Limit] ? params[:Limit].to_i : 0
  
        # logger.debug(request.url)
        # @offset = 10
        @current_posts = @current_user.feed(@Offset, @Limit)
  
        render "users/auto_feed", formats: :json, handlers: "jbuilder"
      end
  
      # userのliked_postsのindexを取得
      def auto_likes
        render json: { liked_posts: @current_user.liked_posts.ids }
      end
    end
  end