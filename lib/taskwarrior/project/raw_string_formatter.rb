require 'ostruct'

module Taskwarrior
  class Project::RawStringFormatter

    attr_reader :slug, :project_data

    def initialize(data)
      @project_data = data
    end

    def name
      split_data.first
    end

    def task_count
      split_data.last
    end

    def nesting_level
      m = project_data.match(/^\s+/)
      if m
        m[0].length / 2
      else
        0
      end
    end

    private

    def lstrip_data
      project_data.lstrip
    end

    def split_data
      lstrip_data.split(/\s+/)
    end
  end
end
