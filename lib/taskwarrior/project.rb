module Taskwarrior
  class Project

    attr_reader :name, :nesting_level, :slug

    def initialize(arr)
      @name = arr[0]
      @nesting_level = arr[1]
      @slug = arr[2]
    end
  end
end
