module Taskwarrior
  class Tag

    attr_reader :name, :slug, :task_count

    def initialize(arr)
      @name = arr[0]
      @slug = arr[2]
      @task_count = arr[3]
    end
  end
end
