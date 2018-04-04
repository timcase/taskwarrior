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
        cd = extract_column_data(line)
        next if current_row_is_overflow?(line)
        if next_row_is_overflow?(line)
          cd = concat_column_data_from_next_row(cd, @data.index(line))
        end
        cd
      end.compact[0..-1]
    end


  end

end
