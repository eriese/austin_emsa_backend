require 'responders/api_responder'
class ConfirmationsController < Devise::ConfirmationsController
	self.responder = ApiResponder
	respond_to :json

	def show
		self.resource = resource_class.confirm_by_token(params[:confirmation_token])

		if resource.errors.empty?
			render token_response(resource.id, params[:scope])
		else
			respond_with resource, status: :unprocessable_entity
		end
	end
end
