module Api
    class RelationshipsController < ApplicationController
      before_action :authorized
      before_action :activated_current_user
      before_action :set_user
  
      # POST /relationships
      def create
        @current_user.follow(@user)
        render json:{message: "follow #{@user.name} successfully"}
      end
  
      # DELETE /relationships/:[id]
      def destroy
        @current_user.unfollow(@user)
        render json:{ message: "Unfollow #{@user.name} successfully"}
      end
  
      private
        # Use callbacks to share common setup or constraints between actions.
        def set_user
          @user = User.find(params[:id])
        end
  
    end
  end