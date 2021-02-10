class SheetsController < ApplicationController
	before_action :doorkeeper_authorize!
	skip_before_action :doorkeeper_authorize!, only: [:create]

	def show
		render json: Spreadsheet.by_name(params[:name]), status: :ok
	end

	def create
		user = params.require(:user).permit(:email, :password)
		unless User.find_for_authentication(email: user[:email])&.valid_password?(user[:password])
			render json: 'Incorrect username or password', status: :unauthorized
			return
		end

		sheet_params = params.require(:sheet).permit(:name, :lines)
		new_sheet = Spreadsheet.find_or_initialize_by(name: sheet_params[:name])
		new_sheet.lines = sheet_params[:lines]
		if new_sheet.save
			render status: :ok
		else
			render status: :unprocessable_entity
		end
	end
end
