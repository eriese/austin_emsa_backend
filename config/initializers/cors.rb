# Be sure to restart your server when you modify this file.

# Avoid CORS issues when API is called from the frontend app.
# Handle Cross-Origin Resource Sharing (CORS) in order to accept cross-origin AJAX requests.

# Read more: https://github.com/cyu/rack-cors
Rails.application.config.middleware.insert_before 0, Rack::Cors do
	allow do
		allowed_origins = Rails.env.development? ? ['localhost:8080', 'front.austin_emsa.org:8080'] : [ENV['FRONT_URL']]
		origins *allowed_origins
		resource '*',
			headers: :any,
			expose: ["Authorization"],
			methods: [:get, :patch, :put, :delete, :post, :options],
			credentials: true
	end
end
