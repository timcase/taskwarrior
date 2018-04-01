require 'ostruct'

module Taskwarrior
  class Tag::RawStringFormatter

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

    def slug
      name
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
