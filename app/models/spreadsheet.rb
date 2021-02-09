class Spreadsheet
	include Mongoid::Document

	field :name, type: String
	field :lines, type: String
	index({name: 1}, unique: true)

	@@map = {}

	after_save :update_map
	after_destroy :remove_from_map

	def self.by_name(name)
		@@map[name] ||= Spreadsheet.find_by(name: name)
	end

	def self.update_map(sheet)
		@@map[sheet.name] = sheet
	end

	def self.remove_from_map(sheet)
		@@map.delete(sheet.name)
	end
end
