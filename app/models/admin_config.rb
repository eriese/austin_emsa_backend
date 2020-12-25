class AdminConfig
	include Mongoid::Document
	include Mongoid::Timestamps

	field :key
	field :value

	after_save :update_map
	after_destroy :remove_from_map

	@@config = nil

	def update_map
		@@config[key] = value unless @@config.nil?
	end

	def remove_from_map
		@@config.delete(key) unless @@config.nil?
	end

	def self.config
		@@config ||= HashWithIndifferentAccess[all.map { |i| [i.key, i.value] }]
	end

	def self.update_fields(fields)
		failed = false
		fields.each  do |f|
			next unless config.has_key? f[:key]
			failed ||= !AdminConfig.where(key: f[:key]).update(value: f[:value])
		end
		!failed
	end
end
