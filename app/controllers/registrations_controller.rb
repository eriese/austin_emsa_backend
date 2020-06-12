class RegistrationsController < Devise::RegistrationsController
	skip_before_action :doorkeeper_authorize!
	respond_to :json
end
