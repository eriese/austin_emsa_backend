class RedemptionCode < ApplicationRecord
	belongs_to :user

	scope :unassigned, -> {where(user_id: nil)}

	def self.first_unassigned
		unassigned.first
	end

	def self.bulk_upload(codes)
		now = Time.now
		bulk_insert = codes.map { |c| {code: c, created_at: now, updated_at: now } }
		insert_all(bulk_insert)
	end
end
