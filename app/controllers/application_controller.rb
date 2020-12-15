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
		request.headers['Api-Version'].blank?
	end
end
