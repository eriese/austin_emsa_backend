class TokenInfoController < Doorkeeper::TokenInfoController
	def show
		if doorkeeper_token&.accessible?
			user = User.find(doorkeeper_token.resource_owner_id)
			token_json = doorkeeper_token.as_json.merge(admin: user.admin, config: AdminConfig.config)
			render json: token_json, status: :ok
		else
			error = Doorkeeper::OAuth::InvalidTokenResponse.new
			response.headers.merge!(error.headers)
			render json: error.body, status: error.status
		end
	end
end
