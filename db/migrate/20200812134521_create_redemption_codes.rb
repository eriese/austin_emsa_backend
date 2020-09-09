class CreateRedemptionCodes < ActiveRecord::Migration[6.0]
	def change
		create_table :redemption_codes do |t|
			t.integer :user_id
			t.string :code
			t.string :email
			t.timestamps
			t.index :code, unique: true
		end

		add_foreign_key :redemption_codes, :users
	end
end
