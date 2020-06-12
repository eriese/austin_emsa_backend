class AddUserToShifts < ActiveRecord::Migration[6.0]
	def change
		add_column :shifts, :user_id, :integer
		add_foreign_key :shifts, :users
	end
end
