class RedemptionCodesController < ApplicationController
	respond_to :json
	before_action :doorkeeper_authorize!
	before_action :admin_only, only: [:count, :upload]

	def index
		render json: current_user.redemption_codes, status: :ok
	end

	def create
		new_code = RedemptionCode.first_unassigned
		if new_code.present?
			render json: new_code.update(user_id: current_user.id), status: :ok
		else
			render json: 'Looks like we ran out of codes. Please contact your administrator.', status: :unprocessable_entity
		end
	end

	def count
		render json: RedemptionCode.unassigned.count, status: :ok
	end

	def upload
		codes = params.require(:codes)
		RedemptionCode.bulk_upload(codes)
		count
	end
end
