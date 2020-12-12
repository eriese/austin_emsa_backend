class Shift
	include Mongoid::Document
	include Mongoid::Timestamps

	belongs_to :user

	def self.add_shift_field(shift_field)
		field shift_field.internal_name.to_sym, type: shift_field.db_type
	end

	ShiftField.each {|f| add_shift_field(f)}

	default_scope {where(:shift_date.gte => Date.current)}

	def shift_letter=(new_letter)
		super(new_letter.upcase)
	end

	def shift_start=(new_start)
		super(new_start)
		super(normalize_time(shift_start))
	end

	def shift_end=(new_end)
		super(new_end)
		modified_end = normalize_time(shift_end)
		modified_end += 1.day if shift_end < shift_start
		super(modified_end)
	end

	def self.find_with_email(id)
		select('shifts.*, users.email').where(id: id).joins(:user).first
	end

	def self.with_filters(filters, current_user)
		filter_dates = filters.delete :date
		first_date = Date.parse(filter_dates[0])

		case filters.delete(:date_type).downcase
		when 'before'
			filters[:shift_date.lte] = first_date
			filters[:shift_date.gte] = Date.current
		when 'after'
			filters[:shift_date.gte] = first_date
		when 'on'
			filters[:shift_date] = first_date
		when 'between'
			filters[:shift_date.gte] = first_date
			filters[:shift_date.lte] = Date.parse(filter_dates[1])
		else
			filters[:shift_date.gte] = Date.current
		end

		filters[:shift_letter]&.map! {|l| l.upcase }

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

	private
	def normalize_time(time)
		time.change(day: shift_date.day, month: shift_date.month, year: shift_date.year)
	end
end
