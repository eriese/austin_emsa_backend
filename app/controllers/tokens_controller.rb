class TokensController < Doorkeeper::TokensController

	def revoke
		binding.pry
		if token.blank?
			render json: {}, status: 200
		# The authorization server validates [...] and whether the token
		# was issued to the client making the revocation request. If this
		# validation fails, the request is refused and the client is informed
		# of the error by the authorization server as described below.
		elsif authorized?
			revoke_token
			render json: {}, status: 200
		else
			render json: revocation_error_response, status: :forbidden
		end
	end
end
