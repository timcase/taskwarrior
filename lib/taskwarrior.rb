require 'taskwarrior/base'
require 'taskwarrior/config'
require 'taskwarrior/version'

module Taskwarrior
  # Your code goes here...
  def self.configure
    yield Base.config
  end

  def self.config
    yield Base.config
  end

end
