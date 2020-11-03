class ApiResponder < ActionController::Responder
	def api_behavior
		raise MissingRenderer.new(format) unless has_renderer?

		if post?
			display resource, status: :created, location: api_location
		else
			display resource
		end
	end
end
