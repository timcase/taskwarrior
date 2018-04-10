module Taskwarrior
  class Project

    attr_reader :name, :nesting_level, :slug, :task_count, :extended_name

    def initialize(arr)
      @name = arr[0]
      @nesting_level = arr[1]
      @slug = arr[2]
      @extended_name = arr[3]
      @task_count = arr[4]
    end
  end
end
