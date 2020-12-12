class ShiftField
	include Mongoid::Document

	# the name of the field within the code
	field :internal_name, type: String
	# what is the type of the values of this field?
	field :field_type, type: String, default: 'boolean'
	# is the field shown on the front end?
	field :is_visible, type: Boolean, default: true
	# the name of this field when it is used as a filter
	field :filter_label, type: String
	# an alternative label to show for this field in the shift form is the alt_input_label_conditions are met
	field :alt_filter_label, type: String
	# conditions to check for to show the #alt_filter_label.
	# format: {field: (internal_name), value: (value of field type), logic: ('AND' | 'OR'), exists: (true | false)}
	field :alt_filter_label_conditions, type: Array
	# the label for this field in the shift form
	field :input_label, type: String
	# an alternative label to show for this field in the shift form is the alt_input_label_conditions are met
	field :alt_input_label, type: String
	# conditions to check for to show the #alt_input_label.
	# format: {field: (internal_name), value: (value of field type), logic: ('AND' | 'OR')}
	field :alt_input_label_conditions, type: Array
	# the type of input used to set the field's value
	field :input_type, type: String, default: 'radio'
	# the labels for values for this field
	field :value_labels, type: Array
	# the labels for input values for this field, if they are different from display labels for values
	field :input_value_labels, type: Array
	# the position in the field order this field should display
	field :position, type: Integer

	validates :internal_name, presence: true, uniqueness: true

	def db_type
		case field_type
		when 'boolean'
			Boolean
		when 'integer'
			Integer
		when 'string'
			String
		when 'datetime'
			DateTime
		when 'date'
			Date
		end
	end
end
