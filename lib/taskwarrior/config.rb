module Taskwarrior
  class Config

    attr_reader :verbose, :binary_path
    def initialize(options)
      @verbose = options[:verbose] || false
      @binary_path = options[:binary_path] || '/usr/local/bin/task'
    end
  end

end
