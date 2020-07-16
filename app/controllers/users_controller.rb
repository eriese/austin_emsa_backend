class UsersController < ApplicationController
	respond_to :json
	before_action :doorkeeper_authorize!
	before_action :admin_only

	def index
		@users = User.where(approved: nil)
		render json: @users
	end

	def approve
		user_ids = params.require(:user_ids)
		render json: User.approve(user_ids), status: :ok
	end

	def admin_only
		render json: {}, status: :unauthorized if !current_user.admin?
	end
end
