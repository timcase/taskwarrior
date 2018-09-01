require_relative 'taskwarrior/base'
require_relative 'taskwarrior/base/report'
require_relative 'taskwarrior/config'
require_relative 'taskwarrior/context'
require_relative 'taskwarrior/context_factory'
require_relative 'taskwarrior/info_task'
require_relative 'taskwarrior/info_task_factory'
require_relative 'taskwarrior/field_converter'
require_relative 'taskwarrior/project'
require_relative 'taskwarrior/project/raw_string_formatter'
require_relative 'taskwarrior/project/slug_generator'
require_relative 'taskwarrior/project_factory'
require_relative 'taskwarrior/report'
require_relative 'taskwarrior/report_factory'
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

  def self.open(taskrc_path, data_location, *exec_options)
    Base.open(taskrc_path, data_location, exec_options)
  end

end
