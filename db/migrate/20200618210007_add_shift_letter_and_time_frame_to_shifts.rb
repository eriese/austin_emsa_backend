class AddShiftLetterAndTimeFrameToShifts < ActiveRecord::Migration[6.0]
	def change
		add_column :shifts, :shift_letter, :string
		add_column :shifts, :time_frame, :integer, default: -1
	end
end
