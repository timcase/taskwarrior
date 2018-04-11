require 'ostruct'

module Taskwarrior
  class InfoTask
    def initialize(rows)
      @rows = rows
    end

    def delimiter_row
      @rows[1]
    end

    def delimiter
       delimiter_row.split("\s").map{|dashes| "A#{dashes.strip.length}"}
         .join("A1")
    end

    def split_rows
      @rows[2..@rows.length-1].map{|r| r.unpack(delimiter)}
    end

    def data_rows
      urgency_row = split_rows.detect{|r| r.first == "Urgency"}
      split_rows[0..split_rows.index(urgency_row)-1]
    end

    def data
      names.zip(values)
    end

    def names
      data_rows.map{|r| r.first}
    end

    def values
      data_rows.map{|r| r.last}
    end
  end
end
