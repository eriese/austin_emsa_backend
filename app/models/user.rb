require 'api_versioner'

class User
	include Mongoid::Document
	include Mongoid::Timestamps
	include GlobalID::Identification
	# Include default devise modules. Others available are:
	# :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
	devise :database_authenticatable, :registerable,
				 :recoverable, :validatable, :confirmable

	## Database authenticatable
	field :email,                  type: String, default: ''
	field :encrypted_password,     type: String, default: ''

	## Recoverable
	field :reset_password_token,   type: String
	field :reset_password_sent_at, type: Time

	field :remember_created_at, type: DateTime
	field :approved, type: Boolean
	field :admin, type: Boolean, default: false

	## Trackable
	# field :sign_in_count,          type: Integer, default: 0
	# field :current_sign_in_at,     type: Time
	# field :last_sign_in_at,        type: Time
	# field :current_sign_in_ip,     type: String
	# field :last_sign_in_ip,        type: String

	# Confirmable
	field :confirmation_token,     type: String
	field :confirmed_at,           type: Time
	field :confirmation_sent_at,   type: Time
	# field :unconfirmed_email,    type: String # Only if using reconfirmable

	## Lockable
	# field :failed_attempts,        type: Integer, default: 0 # Only if lock strategy is :failed_attempts
	# field :unlock_token,           type: String # Only if unlock strategy is :email or :both
	# field :locked_at,              type: Time

	index({ email: 1 }, unique: true, sparse: true)
	index({reset_password_token: 1}, unique: true, sparse: true)

	has_many :access_grants,
					 class_name: 'Doorkeeper::AccessGrant',
					 foreign_key: :resource_owner_id,
					 dependent: :delete_all # or :destroy if you need callbacks

	has_many :access_tokens,
					 class_name: 'Doorkeeper::AccessToken',
					 foreign_key: :resource_owner_id,
					 dependent: :delete_all # or :destroy if you need callbacks

	has_many :shifts, dependent: :delete_all
	has_many :redemption_codes

	attr_accessor :request_version

	after_create { AdminDigestJob.schedule }

	def active_for_authentication?
		super && approved?
	end

	def confirmation_required?
		ApiVersioner.version_requires?(request_version, :confirmation) && super
	end

	def inactive_message
		approved? ? super : :not_approved
	end

	def as_json(options = {})
		super(only: [:_id, :email, :approved, :admin])
	end

	def should_auto_approve?
		email.match(/\A[^@\s\/\\]+@austintexas\.gov\z/i).present?
	end

	def claim_redemption_codes
		app_code_match = RedemptionCode.where(email: email)
		return app_code_match.present? && app_code_match.update(user_id: id)
	end

	def auto_approve
		return unless claim_redemption_codes || should_auto_approve?

		self.class.approve(id)
	end

	def self.approve(*user_ids)
		Rails.logger.debug("approving user ids: #{user_ids}")
		users_approved = User.where(:id.in => user_ids).update(approved: true).modified_count
		if users_approved > 0
			codes = RedemptionCode.unassigned.limit(user_ids.size)
			User.where(:id.in => user_ids, approved: true).each_with_index do |u, i|
				codes[i].update(user_id: u.id) if u.redemption_codes.empty? && codes.any?
				# TODO this feels hacky to use to to_s
				ApprovedMailer.approved_email(u.id.to_s).deliver_later
			end
			true
		else
			false
		end
	end

	def self.send_reset_password_instructions(attributes={})
		recoverable = find_or_initialize_with_errors(reset_password_keys, attributes, :not_found)
		if !recoverable.approved?
			recoverable.errors[:base] << I18n.t("devise.failure.not_approved")
		elsif recoverable.persisted?
			recoverable.send_reset_password_instructions
		end
		recoverable
	end

	def will_save_change_to_email?
	end
end
