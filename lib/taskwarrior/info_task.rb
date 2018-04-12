require 'ostruct'

module Taskwarrior
  class InfoTask
    def initialize(rows)
      @rows = rows
    end

    def uuid
      extract_value("uuid")
    end

    def description
      extract_value("description")
    end

    def project
      extract_value("project")
    end

    def tags
      extract_value("tags")
    end

    def due
      extract_value("due")
    end

    def names
      data_rows.map{|r| r.first}
    end

    def values
      data_rows.map{|r| r.last.force_encoding('UTF-8')}
    end

    def data
      names.zip(values)
    end

    private

    def extract_value(name)
      if method_names.any?{|n| n == name}
        values[method_names.index(name)]
      end
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


    def method_names
      names.map{|n| n.downcase.gsub(" ", "-")}
    end

  end
end
