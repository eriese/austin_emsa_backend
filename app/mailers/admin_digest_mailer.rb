class AdminDigestMailer < ApplicationMailer
	def approval_digest(num_users)
		@num_users = num_users
		admins = User.where(admin: true).pluck(:email)
		mail(to: admins, subject: "#{num_users} users need approval to use ShiftRequest")
	end
end
