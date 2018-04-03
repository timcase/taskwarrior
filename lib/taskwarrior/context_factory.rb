module Taskwarrior
  class ContextFactory
    include Base::Report

    def initialize(data)
      @data = data
    end

    def to_a
      contexts
    end

    def contexts
      @contexts ||= build_contexts
    end

    def build_contexts
      rows.map{ |row| Context.new(row)}
    end

  end

end
