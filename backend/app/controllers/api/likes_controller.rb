module Api
    class LikesController < ApplicationController
      before_action :authorized
      before_action :set_variable
  
      def create
        like = @post.likes.build(user_id: @current_user.id)
        if like.save
          render json: { message: "like the post successfully", post: @post }, status: :ok
        else
          render json: { post: @post, current_user: @current_user, message: "Fail to like post" }, status: :bad_request
        end
      end
  
      def destroy
        like = @current_user.likes.find_by(post_id: @post.id)
        if like
          like.destroy
          render json: { message: "Like is cancelled successfully" }, status: :accepted
        else
          render json: { message: "Like is not founded" }, status: :bad_request
        end
      end
  
      private
  
      def set_variable
        post_id = params[:post_id]
        if post_id
          @post = Post.find(post_id)
        else
          render json: { message: "Post id params is missing" }, status: :bad_request
        end
      end
    end
  end