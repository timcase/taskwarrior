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
      command_lines(command('_projects'))
    end

    def tags
      command_lines(command('_tags'))
    end

    private

    def command(cmd)
      `task rc.data.location=#{self.data_location} #{cmd}`.chomp
    end

    def command_lines(cmd)
      op = cmd.encode("UTF-8", "binary", {
        :invalid => :replace,
        :undef => :replace
      })
      op.split("\n")
    end

    def export
      JSON.parse(command('export'))
    end

  end

end
