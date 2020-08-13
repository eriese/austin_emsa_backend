class UsersController < ApplicationController
	respond_to :json
	before_action :doorkeeper_authorize!
	before_action :admin_only

	def index
		get_all = params[:all]
		@users = User.where(approved: get_all)
		render json: @users
	end

	def bulk_approved
		user_ids = params.require(:user_ids)
		render json: User.approve(user_ids), status: :ok
	end

	def bulk_admin
		user_ids = params.require(:user_ids)
		if User.where.not(id: user_ids).update_all(admin: false) && User.where(id: user_ids).update_all(admin: true)
			render json: true, status: :ok
		else
			render json: false, status: :unprocessable_entity
		end
	end
end
