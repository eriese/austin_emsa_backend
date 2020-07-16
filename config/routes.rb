Rails.application.routes.draw do
	use_doorkeeper do
		skip_controllers :applications, :authorized_applications
		controllers tokens: 'tokens'
	end

	devise_for :users,
	defaults: { format: :json },
	path: '',
	path_names: {
		sign_in: 'login',
		sign_out: 'logout',
		registration: 'signup'
	},
	controllers: {
		registrations: 'registrations'
	},
	skip: [:sessions]
	# For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
	resources :shifts
	get '/users', to: 'users#index'
	post '/approve', to: 'users#approve'
end
