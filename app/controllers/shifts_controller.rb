class ShiftsController < ApplicationController

	def index
		@shifts = Shift.all
		render json: @shifts, status: :ok
	end

	def create
		@shift = Shift.new(shift_params)
		@shift.save
		respond_with @shift
	end

	def show
		respond_with Shift.find(params[:id])
	end

	def update
		@shift = Shift.find(params[:id])
		@shift.update(shift_params)
		respond_with @shift
	end

	def destroy
		@shift = Shift.find(params[:id])

		if @shift.destroy
			head(:ok)
		else
			respond_with(@shift)
		end
	end

	private
	def shift_params
		params.require(:shift).permit(:is_field, :position, :is_offering, :shift_date, :is_ocp, :trade_preference, :shift_start, :shift_end, :trade_dates)
	end
end
