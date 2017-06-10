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

    def all
      export.map{|row| Task.new(row)}
    end

    def projects
      res = `task rc.data.location=#{self.data_location} _projects`.chomp
      op = res.encode("UTF-8", "binary", {
        :invalid => :replace,
        :undef => :replace
      })
      op.split("\n")
    end

    def export
      JSON.parse(`task rc.data.location=#{self.data_location} export`)
    end

  end

end
