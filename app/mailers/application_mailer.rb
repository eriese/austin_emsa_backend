class ApplicationMailer < ActionMailer::Base
	default from: "Shift Request App #{ENV['APP_EMAIL']}"
	layout 'mailer'
end
