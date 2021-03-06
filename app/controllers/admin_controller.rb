class AdminController < ApplicationController
	respond_to :json
	before_action :doorkeeper_authorize!
	before_action :admin_only

	def index
		render json: {config: AdminConfig.config, fields: ShiftField.as_map}
	end

	def update
		AdminConfig.update_fields(params.permit(fields: [:key, :value]))
		render json: AdminConfig.config
	end

end
