class Shift < ApplicationRecord

	def self.create_dummy
		true_false = [true, false]
		cur_date = Date.current

		self.create({
			is_field: true_false.sample,
			is_offering: true_false.sample,
			is_ocp: true_false.sample,
			position: [0,1,2,3].sample,
			trade_preference: [-1,0,1].sample,
			shift_date: cur_date - ([1,2,3,-1,-2,-3].sample).days,
			shift_start: DateTime.new(cur_date.year, cur_date.month, cur_date.day, 7),
			shift_end: DateTime.new(cur_date.year, cur_date.month, cur_date.day, 19)
		})
	end
end
