# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

starter_fields = [{
	internal_name: 'is_offering',
	field_type: 'boolean',
	filter_label: 'Post Type',
	input_label: 'Are you offering a shift or picking up a shift?',
	value_labels: ['Offering', 'Seeking'],
	input_value_labels: ['Offering', 'Picking Up'],
	position: 0,
	locked: true,
	display_in_list: true,
	list_row: 0,
	list_column: 0
},{
	internal_name: 'is_field',
	field_type: 'boolean',
	is_visible: true,
	filter_label: 'Comm or Field',
	input_label: 'Is this shift Field or Comm?',
	value_labels: ['Field', 'Comm'],
	position: 1,
	display_in_list: true,
	list_row: 2,
	list_column: 0
},{
	internal_name: 'position',
	field_type: 'integer',
	is_visible: true,
	filter_label: 'Position',
	input_label: 'What position is the shift for?',
	alt_input_label: 'What\'s your position?',
	alt_input_label_conditions: [{field: 'is_offering', value: false}],
	value_labels: ['Medic', 'CS', 'Captain', 'Commander'],
	position: 2,
	display_in_list: true,
	list_row: 0,
	list_column: 2
},{
	internal_name: 'is_ocp',
	field_type: 'boolean',
	is_visible: true,
	filter_label: 'Shift Type',
	input_label: 'What type of shift are you offering?',
	alt_input_label: 'What type of shift are you looking for?',
	alt_input_label_conditions: [{field: 'is_offering', value: false}],
	value_labels: ['OCP', 'Shift'],
	position: 3,
	display_in_list: true,
	list_row: 0,
	list_column: 1
},{
	internal_name: 'unit_number',
	field_type: 'integer',
	is_visible: true,
	input_label: 'What unit is the shift with? (optional)',
	filter_label: 'Unit',
	alt_filter_label: nil,
	alt_filter_label_conditions: [{exists: true}, {field: 'is_offering', value: false, logic: 'AND'}],
	alt_input_label: nil,
	alt_input_label_conditions: [{field: 'is_offering', value: false}],
	input_type: 'number',
	position: 4
},{
	internal_name: 'shift_letter',
	field_type: 'integer',
	is_visible: true,
	filter_label: 'A, B, C, or D?',
	alt_filter_label: nil,
	alt_filter_label_conditions: [{exists: true}, {field: 'is_offering', value: false, logic: 'AND'}],
	input_label: 'Which shift?',
	alt_input_label_conditions: [{field: 'is_offering', value: false}],
	value_labels: ['A', 'B', 'C', 'D'],
	position: 5,
	display_in_list: true,
	list_row: 2,
	list_column: 1
},{
	internal_name: 'time_frame',
	field_type: 'integer',
	is_visible: true,
	filter_label: '12, 24, or Other?',
	input_label: 'Is this shift a 12, a 24, or something else? (explain something else in the notes)',
	alt_input_label: 'Should this shift be a 12, a 24, or something else? (explain something else in the notes)',
	alt_input_label_conditions: [{field: 'is_offering', value: false}],
	value_labels: ['12', '24', 'Other'],
	position: 6,
	display_in_list: true,
	list_row: 2,
	list_column: 2
},{
	internal_name: 'shift_date',
	field_type: 'date',
	is_visible: true,
	filter_label: 'Dates',
	input_label: 'What date is the shift you\'re offering?',
	alt_input_label: 'What date are you looking for a shift on?',
	alt_input_label_conditions: [{field: 'is_offering', value: false}],
	input_type: 'date',
	position: 7,
	locked: true,
	display_in_list: false
},{
	internal_name: 'shift_start',
	field_type: 'datetime',
	is_visible: true,
	input_label: 'When does the shift start?',
	alt_input_label: 'When should the shift start?',
	alt_input_label_conditions: [{field: 'is_offering', value: false}],
	input_type: 'time',
	position: 8,
	locked: true,
	display_in_list: false
},{
	internal_name: 'shift_end',
	field_type: 'datetime',
	is_visible: true,
	input_label: 'When does the shift end?',
	alt_input_label: 'When should the shift end?',
	alt_input_label_conditions: [{field: 'is_offering', value: false}],
	input_type: 'time',
	position: 9,
	locked: true,
	display_in_list: false
},{
	internal_name: 'trade_preference',
	field_type: 'integer',
	is_visible: true,
	filter_label: 'Trade Preference',
	input_label: 'Do you want a trade for this shift?',
	value_labels: ['No Trade', 'Open to Trade', 'Trade Only'],
	input_value_labels: ['No Thanks', "I'm Open", 'Trade Required'],
	position: 10,
	display_in_list: true,
	list_row: 2,
	list_column: 3
},{
	internal_name: 'trade_dates',
	field_type: 'string',
	is_visible: true,
	filter_label: 'Trade Dates',
	alt_filter_label: nil,
	alt_filter_label_conditions: [{exists: true}, {field: 'trade_preference', value: 0, logic: 'AND'}],
	input_label: 'What dates would you be open to trading for?',
	alt_input_label: nil,
	alt_input_label_conditions: [{field: 'trade_preference', value: 0}],
	input_type: 'text',
	position: 11
},{
	internal_name: 'notes',
	field_type: 'string',
	is_visible: true,
	filter_label: 'Notes',
	alt_filter_label: nil,
	alt_filter_label_conditions: [{exists: false}],
	input_label: 'Any notes about the shift?',
	input_type: 'textarea',
	position: 12
}]
ShiftField.create(starter_fields)
