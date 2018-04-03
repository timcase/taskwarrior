module Taskwarrior
  class Report
    include Base::Report

    def initialize(data)
      @data = data
    end

    def tasks
      @tasks ||= build_tasks
    end

    def build_tasks
      rows.map{ |row| Task.new(Hash[column_names.zip(row)]) }
    end

  end
end
