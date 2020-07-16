module EmsaErrors
	module DoorkeeperErrors
		class InactiveError < Doorkeeper::Errors::DoorkeeperError
			def initialize(user)
				@inactive_message = user.inactive_message
			end

			def type
				@inactive_message
			end
		end
	end
end
