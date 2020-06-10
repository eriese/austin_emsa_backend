class CreateShifts < ActiveRecord::Migration[6.0]
	def change
		create_table :shifts do |t|
			t.boolean :is_field
			t.integer :position
			t.boolean :is_offering
			t.date :shift_date
			t.boolean :is_ocp
			t.integer :trade_preference
			t.datetime :shift_start
			t.datetime :shift_end
			t.text :trade_dates
			t.text :notes
			t.timestamps
		end
	end
end
