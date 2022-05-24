module Api
    class PasswordResetsController < ApplicationController
      before_action :get_user, only:[:edit,:update]
      before_action :valid_user, only:[:edit,:update]
  
      #Post /password_reset
      def create
        @user = User.find_by(email: params[:password_reset][:email].downcase)
        if @user
          @user.create_reset_digest
          @user.send_password_reset_email
          render json: {message:"Email sent with password reset instructions"}, status: :ok
        else
          render json: {message:"Email address not found"}, status: :bad_request
        end
      end
  
      #Put /password_reset/:id
      def update
        # render json:{user: @user,message: "Password is reset successfully"},status: :ok
        if @user.update(user_params)
          render json: {user: @user,message:"Password is reset successfully"},status: :ok, location: api_user_url(@user)
        else
          render json: { errors: @user.errors}, status: :bad_request
        end
      end
  
      private
        def user_params
          params.require(:user).permit(:password, :password_confirmation)
        end
  
        def get_user
          email = CGI.unescape(params[:email])
          @user = User.find_by(email: email)
        end
  
        # # 正しいユーザーかどうか確認する
        def valid_user
          unless @user && @user.activated? && @user.authenticated?(:reset, params[:id])
            render json: {message:"You are not correct user",id: params[:id]}, status: :unauthorized
          end
        end
    end
  end