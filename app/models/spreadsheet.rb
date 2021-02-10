class Spreadsheet
	include Mongoid::Document

	field :name, type: String
	field :lines, type: String
	index({name: 1}, unique: true)

	@@map = {}

	after_save :update_map
	after_destroy :remove_from_map

	def update_map
		@@map[name] = self
	end

	def remove_from_map
		@@map.delete(name)
	end

	def self.by_name(name)
		@@map[name] ||= Spreadsheet.find_by(name: name)
	end
end
