require_relative 'taskwarrior/base'
require_relative 'taskwarrior/config'
require_relative 'taskwarrior/project'
require_relative 'taskwarrior/project/raw_string_formatter'
require_relative 'taskwarrior/project/slug_generator'
require_relative 'taskwarrior/project_factory'
require_relative 'taskwarrior/report'
require_relative 'taskwarrior/task'
require_relative 'taskwarrior/version'

module Taskwarrior
  # Your code goes here...
  def self.configure
    yield Base.config
  end

  def self.config
    yield Base.config
  end

  def self.open(data_location)
    Base.open(data_location)
  end

end
