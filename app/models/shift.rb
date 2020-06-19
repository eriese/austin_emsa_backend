class Shift < ApplicationRecord
	belongs_to :user

	default_scope {where(shift_date: Date.current..Float::INFINITY)}

	def self.with_filters(filters, current_user)
		select('shifts.*, users.email').where(filters).where.not(user_id: current_user.id).joins(:user)
	end

	def self.create_dummy(*user_ids)
		true_false = [true, false]
		cur_date = Date.current + 10.days

		self.create({
			is_field: true_false.sample,
			is_offering: true_false.sample,
			is_ocp: true_false.sample,
			position: [0,1,2,3].sample,
			trade_preference: [-1,0,1].sample,
			shift_date: cur_date - ([1,2,3,-1,-2,-3].sample).days,
			shift_start: DateTime.new(cur_date.year, cur_date.month, cur_date.day, 7),
			shift_end: DateTime.new(cur_date.year, cur_date.month, cur_date.day, 19),
			shift_letter: ['A', 'B', 'C', 'D'].sample,
			time_frame: [12, 24, -1].sample,
			user_id: user_ids.sample
		})
	end
end
