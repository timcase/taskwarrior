require_relative 'taskwarrior/base'
require_relative 'taskwarrior/config'
require_relative 'taskwarrior/project'
require_relative 'taskwarrior/project/raw_string_formatter'
require_relative 'taskwarrior/project/slug_generator'
require_relative 'taskwarrior/project_factory'
require_relative 'taskwarrior/report'
require_relative 'taskwarrior/tag'
require_relative 'taskwarrior/tag/raw_string_formatter'
require_relative 'taskwarrior/tag_factory'
require_relative 'taskwarrior/task'
require_relative 'taskwarrior/version'
require_relative 'taskwarrior/virtual_tag'
require_relative 'taskwarrior/virtual_tag_factory'

module Taskwarrior
  # Your code goes here...
  def self.configure
    yield Base.config
  end

  def self.config
    yield Base.config
  end

  def self.open(taskrc_path, data_location)
    Base.open(taskrc_path, data_location)
  end

end
