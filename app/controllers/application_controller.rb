class ApplicationController < ActionController::API
	def current_user
		@current_user ||= if doorkeeper_token
			User.find(doorkeeper_token.resource_owner_id)
		else
			warden.authenticate(scope: :user, store: false)
		end
	end

	def admin_only
		render json: {}, status: :unauthorized if !current_user.admin?
	end

	def is_unversioned?
		ApplicationController.request_is_unversioned?(request)
	end

	def token_response(user_id, *scopes)
		access_token = Doorkeeper::AccessToken.create(
			resource_owner_id: user_id,
			refresh_token: generate_refresh_token,
			expires_in: Doorkeeper.configuration.access_token_expires_in.nil? ? nil : Doorkeeper.configuration.access_token_expires_in.to_i,
			scopes: scopes
		)

		t_response = Doorkeeper::OAuth::TokenResponse.new(access_token)
		headers.merge!(t_response.headers)
		{json: t_response.body, status: t_response.status}
	end

	def generate_refresh_token
		loop do
			token = SecureRandom.hex(32)
			unless Doorkeeper::AccessToken.where(refresh_token: token).exists?
				break token
			end
		end
	end

	def self.request_is_unversioned?(request)
		request.headers['Api-Version'].blank?
	end
end
