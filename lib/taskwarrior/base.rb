require 'json'
require 'open3'
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
      @filter = []
    end

    def filter
      @filter.join(" ")
    end

    def project(name)
      @filter << "project:#{name}"
      self
    end

    def tag(name)
      @filter << "+#{name}"
      self
    end

    def list
      Taskwarrior::Report.new(command_lines(command("list")))
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

    def execute(cmd)
      command_lines(command(cmd))
    end

    def export
      JSON.parse(command('export'))
    end

    private
    def command(cmd)
      e = "task rc.data.location=#{self.data_location} #{cmd}"
      stdout, stderr, status = Open3.capture3(e)
      stdout.chomp
    end

    def command_lines(cmd)
      op = cmd.encode("UTF-8", "binary", {
        :invalid => :replace,
        :undef => :replace
      })
      op.split("\n")
    end

  end

end
