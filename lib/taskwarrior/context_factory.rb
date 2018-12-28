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
    def rows
      data_rows.map do |line|
        extract_column_data(line)
      end.compact[0..-1]
    end


  end

end
