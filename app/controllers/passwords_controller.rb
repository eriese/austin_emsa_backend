require 'responders/api_responder'
class PasswordsController < Devise::PasswordsController
	self.responder = ApiResponder
	respond_to :json

	def after_resetting_password_path_for(resource)
	end
end
