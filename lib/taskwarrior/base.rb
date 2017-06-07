require 'json'
module Taskwarrior
	class Base
    attr_reader :data_location

    def self.config
      return @@config ||= Config.new
    end

    def self.open(data_location)
      self.new(data_location)
    end

    def initialize(data_location)
      @data_location = data_location
    end

    def export
      JSON.parse(`task rc.data.location=#{self.data_location} export`)
    end

	end

end
