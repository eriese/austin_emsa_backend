class SheetsController < ApplicationController
	def show
		render json: Spreadsheet.by_name(params[:name]), status: :ok
	end

	def create
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
