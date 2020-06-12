class SessionsController < Devise::SessionsController
	# respond_to :json
	before_action :doorkeeper_authorize!, only: [:destroy]

	# def create
	# 	binding.pry
	# 	super
	# end
	# 	user = User.find_for_database_authentication(email: params[:email])

	# def destroy
	# 	binding.pry
	# 	revoke
	# end
	# private

	# def respond_with(resource, _opts = {})
	# 	render json: resource
	# end

	# def respond_to_on_destroy
	# 	head :no_content
	# end
end
