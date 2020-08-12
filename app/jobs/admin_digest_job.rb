class AdminDigestJob < ApplicationJob
	queue_as :digest

	@@current_job = nil

	def perform()
		@@current_job = nil
		self.class.schedule
		waiting_users = User.where(approved: nil).count
		return if waiting_users == 0

		AdminDigestMailer.approval_digest(waiting_users).deliver_now
	end

	def self.schedule
		return false if @@current_job.present?

		today = DateTime.current.in_time_zone('America/Chicago')
		send_at = DateTime.new(today.year, today.month, today.day, 17, 00, 0, '-5')
		send_at += 1.day if send_at < today
		@@current_job = delay(run_at: send_at).perform_now
	end
end
