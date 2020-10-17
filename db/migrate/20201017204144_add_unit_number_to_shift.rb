class AddUnitNumberToShift < ActiveRecord::Migration[6.0]
	def change
		add_column :shifts, :unit_number, :integer, after: :is_ocp
	end
end
