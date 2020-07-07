module CookieTokenResponse
	def is_mobile?
		token.scopes.scopes? ['native']
	end

	def body
		return super if is_mobile?

		super.except('access_token')
	end

	def headers
		return super if is_mobile?

		cookie_args = [
			"access_token=#{token.token}",
			"Expires=#{DateTime.current + 30.days}",
			'Path=/',
			'HttpOnly'
		]

		# if Rails.env.production?
		#   cookie_args.push('Secure')
		# end

		cookie = cookie_args.join('; ')
		super.merge({'Set-Cookie' => cookie})
	end
end
