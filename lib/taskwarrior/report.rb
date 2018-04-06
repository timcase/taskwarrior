module Taskwarrior
  class Report
    include Base::Report

    attr_reader :name, :description

    def initialize(data = nil, name = nil, description = nil)
      @data = data
      @name = name
      @description = description
    end

    def tasks
      @tasks ||= build_tasks
    end

    def build_tasks
      rows.map{ |row| Task.new(Hash[column_names.zip(row)]) }
    end

  end
end
