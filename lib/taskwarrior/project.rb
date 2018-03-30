require 'ostruct'

module Taskwarrior
  class Project

    def initialize(data)
      @data = data
    end

    def name
      split_data.first
    end

    def task_count
      split_data.last
    end

    def nesting_level
      m = @data.match(/^\s+/)
      if m
        m[0].length / 2
      else
        0
      end
    end

    private

    def lstrip_data
      @data.lstrip
    end

    def split_data
      lstrip_data.split(/\s+/)
    end
  end
end
