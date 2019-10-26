module Taskwarrior
  class Config

    attr_reader :verbose, :bin_path
    def initialize(options)
      @verbose = options[:verbose] || false
      @bin_path = options[:bin_path] || '/usr/local/bin/task'
    end
  end

end
