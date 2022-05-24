module Api
    class PostsController < ApplicationController
        before_action :authorized, only: [:create, :destroy, :update]
        before_action :activated_current_user, only: [:create, :destroy, :update]
        before_action :set_variable, only: [:destroy, :show, :update, :liked]
        before_action :correct_user, only: [:destroy, :update]

        def show
            @gravator_url = gravator_for(@user)
            render "posts/show", formats: :json, handlers: "jbuilder"
        end

        def create
            post = @current_user.posts.build(post_params)
            # @post.image.attach(params[:post][:image])
            if post.save
                if post.image.attached?
                render json: { post: post, image: url_for(post.image), message: "Post created with Image" }, status: :ok
                else
                render json: { post: post, message: "Post created" }, status: :ok
                end
            else
                render json: { post: post, message: "Fail to create post" }, status: :bad_request
            end
        end

        def update
            if @post.update(post_params)
                render json: { post: @post, message: "Post updated Successfully" }
            else
                render json: { post: @post, message: "Fail to create post" }, status: :bad_request
            end
        end

        def destroy
            if @current_user == @user || @current_user.admin?
                @post.destroy
                render json: { message: "Post deleted" }, status: :accepted
            else
                render json: { message: "You are not correct user" }, status: :unprocessable_entity
            end
        end

        def liked
            @liked_users = @post.liked_users
            render "posts/liked", formats: :json, handlers: "jbuilder"
        end

        private

        def post_params
            params.require(:post).permit(:content, :image)
        end

        def set_variable
            @post = post.find(params[:id])
            @user = User.find(@post.user_id)
        end
    end
end
