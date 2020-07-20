class TokensController < Doorkeeper::TokensController

	def revoke
		if token.blank?
			render json: {}, status: 200
		# The authorization server validates [...] and whether the token
		# was issued to the client making the revocation request. If this
		# validation fails, the request is refused and the client is informed
		# of the error by the authorization server as described below.
		elsif authorized?
			revoke_token
			response.headers.merge! TokensController.cookie_header('', 10.days.ago)

			render json: {}, status: 200
		else
			render json: revocation_error_response, status: :unauthorized
		end
	end

	def token
		@token ||= super || Doorkeeper.config.access_token_model.by_token(request.cookies['access_token'])
	end

	def self.cookie_header(token_string, expire_in)
		cookie_args = [
			"access_token=#{token_string}",
			"expires=#{expire_in.inspect}",
			'path=/',
			'HttpOnly'
		]

		if Rails.env.production?
			cookie_args.push('Secure')
			cookie_args.push('SameSite=None')
		end

		cookie = cookie_args.join('; ')
		{'Set-Cookie' => cookie}
	end
end

