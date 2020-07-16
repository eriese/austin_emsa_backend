class TokenInfoController < ApplicationController
	def show
		def show
			if doorkeeper_token&.accessible?
				token_json = doorkeeper_token.as_json.merge(admin: current_user.admin)
				render json: token_json, status: :ok
			else
				error = OAuth::InvalidTokenResponse.new
				response.headers.merge!(error.headers)
				render json: error.body, status: error.status
			end
		end
	end
end
