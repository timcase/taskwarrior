module Taskwarrior
  class Project

    attr_reader :name, :nesting_level, :slug, :task_count

    def initialize(arr)
      @name = arr[0]
      @nesting_level = arr[1]
      @slug = arr[2]
      @task_count = arr[3]
    end
  end
end
