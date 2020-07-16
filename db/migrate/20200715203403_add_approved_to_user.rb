class AddApprovedToUser < ActiveRecord::Migration[6.0]
	def change
		add_column :users, :approved, :boolean
		add_column :users, :admin, :boolean, default: false
	end
end
