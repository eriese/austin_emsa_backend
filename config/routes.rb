Rails.application.routes.draw do

	use_doorkeeper do
		skip_controllers :applications, :authorized_applications
		controllers tokens: 'tokens', token_info: 'token_info'
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

	get '/codes/count', to: 'redemption_codes#count'
	post '/codes/upload', to: 'redemption_codes#upload'
	resources :redemption_codes, path: 'codes', only: [:index, :create]

	get '/users', to: 'users#index'
	post '/bulk_approved', to: 'users#bulk_approved'
	post '/bulk_admin', to: 'users#bulk_admin'
end
