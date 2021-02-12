module ApiVersioner
	VERSION_REQUIREMENTS = {
		confirmation: Gem::Version.new('2.1')
	}

	def self.version_requires?(version_name, requirement)
		return false unless version = parse_version(version_name)
		VERSION_REQUIREMENTS.has_key?(requirement) && VERSION_REQUIREMENTS[requirement] <= version
	end

	def self.parse_version(version_name)
		version_name && Gem::Version.new(version_name.sub('v', ''))
	end
end
