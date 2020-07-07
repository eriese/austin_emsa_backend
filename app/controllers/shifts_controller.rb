class ShiftsController < ApplicationController
	respond_to :json
	before_action :doorkeeper_authorize!

	def index
		if (params[:is_user])
			@shifts = current_user.shifts
		else
			filters = filter_params
			@shifts = Shift.unscoped.with_filters(filters, current_user)
		end
		render json: @shifts, status: :ok
	end

	def create
		@shift = current_user.shifts.new(shift_params)
		if @shift.save
			render json: @shift, status: :ok
		else
			render json: @shift.errors, status: :unprocessable_entity
		end
	end

	def show
		@shift = Shift.unscoped.find_with_email(params[:id])
		if @shift
			render json: @shift, status: :ok
		else
			render json: {}, status: :not_found
		end
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
		params.require(:shift).permit(:is_field, :position, :is_offering, :shift_date, :is_ocp, :trade_preference, :shift_start, :shift_end, :trade_dates, :notes)
	end
	def filter_params
		params.permit(:date_type, is_field: [], position: [], is_offering: [], is_ocp: [], trade_preference: [], date: [], shift_letter: [])
	end
end
