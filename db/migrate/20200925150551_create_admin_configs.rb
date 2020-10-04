class CreateAdminConfigs < ActiveRecord::Migration[6.0]
	def change
		create_table :admin_configs do |t|
			t.string :key, null: false, index: {unique: true}
			t.text :value, null: false
			t.timestamps
		end

		AdminConfig.create(key: 'email_warning', value: '**REMINDER: This app is to help match trades and FYOC requests. To complete trades, use the Telestaff website. To complete FYOC, make sure both parties have agreed through email and forward to EMSSchedulers@austintexas.gov. FYOC requests less than 72 hours will require command approval.**')
	end
end
