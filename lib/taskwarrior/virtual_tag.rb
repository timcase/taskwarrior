module Taskwarrior
  class VirtualTag

    attr_reader :name, :slug, :description

    def initialize(arr)
      @name = arr[0].rstrip.lstrip
      @description = arr[1]
      @slug = @name
    end
  end
end
