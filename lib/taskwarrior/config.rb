module Taskwarrior
  class Config

    attr_reader :verbose, :dry_run, :bin_path
    def initialize(options)
      @verbose = options[:verbose] || false
      @dry_run = options[:dry_run] || false
      @bin_path = options[:bin_path] || '/usr/local/bin/task'
    end
  end

end
