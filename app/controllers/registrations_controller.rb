class RegistrationsController < Devise::RegistrationsController
	# skip_before_action :doorkeeper_authorize!
	respond_to :json

	def create
		super do |resource|
			resource.auto_approve
		end
	end
end
