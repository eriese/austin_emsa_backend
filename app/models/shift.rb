class Shift
	include Mongoid::Document
	include Mongoid::Timestamps

	OLD_API_VALUES = {
		time_frame: ['12','24','-1'],
		trade_preference: ['-1','0','1'],
		shift_letter: ['A','B','C','D']
	}

	belongs_to :user
	field :email, type: String

	def self.add_shift_field(shift_field)
		field shift_field.internal_name.to_sym, type: shift_field.db_type
	end

	ShiftField.each {|f| add_shift_field(f)}

	default_scope {where(:shift_date.gte => Date.current)}

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

	def as_json(options = {})
		super(options.merge(methods: [:id]))
	end

	def as_backwards_compatible_json
		orig = as_json
		OLD_API_VALUES.each {|k,v| orig[k] = v[send(k)]}
		orig
	end

	def self.new_from_old_api(new_attrs)
		OLD_API_VALUES.each {|k,v| new_attrs[k] = v.index(new_attrs[k]) if new_attrs.has_key?(k)}
		self.new(new_attrs)
	end

	def self.find_with_email(id)
		where(id: id).first
	end

	def self.with_filters(filters, current_user)
		filter_dates = filters.delete :date
		first_date = Date.parse(filter_dates[0])
		date_criteria = {:user_id.ne => current_user.id}

		case filters.delete(:date_type).downcase
		when 'before'
			date_criteria[:shift_date.lte] = first_date
			date_criteria[:shift_date.gte] = Date.current
		when 'after'
			date_criteria[:shift_date.gte] = first_date
		when 'on'
			date_criteria[:shift_date] = first_date
		when 'between'
			date_criteria[:shift_date.gte] = first_date
			date_criteria[:shift_date.lte] = Date.parse(filter_dates[1])
		else
			date_criteria[:shift_date.gte] = Date.current
		end

		where(date_criteria).in(filters)
	end

	def self.create_dummy(*user_ids)
		true_false = [true, false]
		cur_date = Date.current + 30.days
		users = User.find(user_ids).to_a
		user = users.sample

		shift_attrs = {
			user_id: user.id,
			email: user.email
		}

		ShiftField.as_map.each do |k,v|
			val = case k
			when 'shift_date'
				cur_date - ([1,2,3,-1,-2,-3].sample).days
			when 'shift_start'
				DateTime.new(cur_date.year, cur_date.month, cur_date.day, 7)
			when 'shift_end'
				DateTime.new(cur_date.year, cur_date.month, cur_date.day, 19)
			else
				next if v.value_labels.blank?

				sample_set = if v.field_type == 'boolean'
					true_false
				else
					(0...v.value_labels.size).to_a
				end

				sample_set.sample
			end

			shift_attrs[k] = val
		end

		self.create(shift_attrs)
	end

	private
	def normalize_time(time)
		time.change(day: shift_date.day, month: shift_date.month, year: shift_date.year)
	end
end
