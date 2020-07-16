class ApprovedMailer < ApplicationMailer
	def approved_email(user_id)
		@user = User.find(user_id)
		mail(to: @user.email, subject: 'Welcome to ShiftRequest')
	end
end
