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
      split_data.last.to_i
    end

    private

    def split_data
      @data.split(/\s+/)
    end
  end
end
