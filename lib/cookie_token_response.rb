module CookieTokenResponse
	def is_mobile?
		token.scopes.scopes? ['native']
	end

	def body
		return super if is_mobile?

		user = User.find(token.resource_owner_id)
		super.except('access_token').merge(admin: user.admin)
	end

	def headers
		return super if is_mobile?

		cookie_header = TokensController.cookie_header(token.token, 30.days.from_now)

		super.merge(cookie_header)
	end
end
