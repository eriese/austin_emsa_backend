# Preview all emails at http://localhost:3000/rails/mailers/approved_mailer
class ApprovedMailerPreview < ActionMailer::Preview
	def approved_email
		ApprovedMailer.approved_email(User.first.id)
	end
end
