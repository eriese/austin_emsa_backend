namespace :icontact do
	def get_contacts(offset)
		creds = Rails.application.credentials.icontact
		unless creds.present?
			Rails.logger.warn 'no icontact credentials found'
			return
		end

		Rails.logger.info "Getting users with offset #{offset}"
		req = HTTP.headers(
			'Accept' => 'application/json',
			'Content-Type' => 'application/json',
			'API-Version' => '2.2',
			'API-AppId' => creds[:app_id],
			'API-Username' => creds[:username],
			'API-Password' => creds[:password]).get("https://app.icontact.com/icp/a/608950/c/3946/contacts?status=total&offset=#{offset}")
		req.parse
	end

	task :bulk_assign_codes, [:starting_offset] => :setup_logger do |_t, args|
		offset = args[:starting_offset].to_i
		total = 1000
		while offset < total
			details = get_contacts(offset)
			break unless details.present?

			total = details['total']
			offset += details['limit']

			break unless RedemptionCode.icontact_assign *details['contacts']
		end

		Rails.logger.info "Finished assigning codes to #{total} users."
	end
end
