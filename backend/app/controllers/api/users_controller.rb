class Api::UsersController < ApplicationController
  before_action :authorized, only: [:update, :destroy]
  before_action :activated_current_user, only: [:update, :destroy]
  before_action :set_user, except: [:index, :create]
  before_action :correct_user, only: [:update, :destroy]

  def index
    @users = User.where(activated: true).order(:created_at)

    render "users/index", formats: :json, handlers: "jbuilder"
  end

  def show
    @gravator_url = gravator_for(@user)
    @following_count = @user.following.count
    @followers_count = @user.followers.count
    @posts = @user.posts.with_attached_image

    render "users/show", formats: :json, handlers: "jbuilder"
  end

  def create
    @user = User.new(user_params)
    if @user.save
      @user.send_activation_email
      payload = { user_id: @user.id }
      token = encode_token(payload)
      render json: { user: @user, token: token, gravator_url: gravator_for(@user) }, status: :created, location: api_user_url(@user)
    else
      render json: { errors: @user.errors }, status: :bad_request
    end
  end

  def update
    if @user.update(user_params)
      render json: { id: @user.id, name: @user.name, email: @user.email, gravator_url: gravator_for(@user) }, status: :ok, location: api_user_url(@user)
    else
      render json: { errors: @user.errors }, status: :bad_request
    end
  end

  def destroy
    @user.destroy
    render json: { message: "User is deleted successfully" }, status: :accepted
  end

  def following
    @following = @user.following
    @gravator_url = gravator_for(@user)
    render "users/following", formats: :json, handlers: "jbuilder"
  end

  def followers
    @followers = @user.followers
    @gravator_url = gravator_for(@user)
    render "users/followers", formats: :json, handlers: "jbuilder"
  end

  def likes
    @liked_posts = @user.liked_posts.with_attached_image
    render "users/likes", formats: :json, handlers: "jbuilder"
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
