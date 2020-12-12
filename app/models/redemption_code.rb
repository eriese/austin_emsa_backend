class RedemptionCode
	include Mongoid::Document
	belongs_to :user, optional: true
	field :code, type: String
	field :email, type: String
	index({code: 1}, unique: true)

	scope :unassigned, -> {where(user_id: nil, email: nil)}

	def self.first_unassigned
		unassigned.first
	end

	def self.bulk_upload(codes)
		now = Time.now
		bulk_insert = codes.map { |c| {code: c, created_at: now, updated_at: now } }
		insert_all(bulk_insert)
	end

	def self.icontact_assign(*details)
		creds = Rails.application.credentials.icontact
		unless creds.present?
			Rails.logger.warn 'no icontact credentials found'
			return false
		end

		email_codes = unassigned.limit(details.size)
		if email_codes.size < details.size
			Rails.logger.warn 'not enough codes to assign to all emails. Upload more codes and try again.'
			return false
		end

		db_update = []
		icontact_update = []

		now_time = DateTime.current
		details.each_with_index do |detail, i|
			code = email_codes[i]
			db_update << {email: detail['email'], code: code.code, created_at: code.created_at, updated_at: DateTime.current}
			icontact_update << {contactId: detail['contactId'], apple_code: code.code}
		end

		response = HTTP.headers(
			'Accept' => 'application/json',
			'Content-Type' => 'application/json',
			'API-Version' => '2.2',
			'API-AppId' => creds[:app_id],
			'API-Username' => creds[:username],
			'API-Password' => creds[:password]).post('https://app.icontact.com/icp/a/608950/c/3946/contacts', json: icontact_update)

		unless response.status.success? && response.parse['contacts'].size == details.size
			Rails.logger.warn 'could not assign codes in icontact:'
			Rails.logger.warn response.body.to_s
			return false
		end

		upsert_all(db_update, unique_by: :code)
		Rails.logger.info 'successfully assigned codes'
		return true
	end
end
