module Taskwarrior
  class Config
    attr_writer :binary_path

    def initialize
      @binary_path = nil
    end

    def binary_path
      @binary_path || 'task'
    end

  end

end
