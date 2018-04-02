module Taskwarrior
  class VirtualTag

    attr_reader :name, :slug, :description

    def initialize(arr)
      @name = arr[0].chomp
      @description = arr[1].chomp
      @slug = @name
    end
  end
end
