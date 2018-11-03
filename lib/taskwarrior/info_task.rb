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

    def due
      extract_value("due")
    end

    def wait
      extract_value("waiting_until")
    end

    def start
      extract_value("start")
    end

    def end_date
      extract_value("end")
    end

    def scheduled
      extract_value("scheduled")
    end

    def until
      extract_value("until")
    end

    def priority
      extract_value("priority")
    end

    def recurrence
      extract_value("recurrence")
    end

    def status
      extract_value('status')
    end

    def tags
      res = extract_value("tags")
      res.nil? ? [] : res.split("\s")
    end

    def names
      data_rows.map{|r| r.first}
    end

    def values
      data_rows.map{|r| r.last.encode('UTF-8', invalid: :replace,
                                      undef: :replace).gsub('�', '').strip }

    end

    def data
      names.zip(values)
    end

    def fields
      data.to_h
    end

    private

    def extract_value(name)
      if method_names.any?{|n| n == name}
        i = method_names.index(name)
        mn = method_names[(i+1)..(method_names.count - 1)]
        ei = mn.find_index{|element| element.length > 0}
        if (ei.nil? || ei == 0)
          values[i]
        else
          values[i..(ei + 1)].join(" ")
        end
      end
    end
    # def extract_value(name)
    #   if method_names.any?{|n| n == name}
    #     values[method_names.index(name)]
    #   end
    # end

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
      names.map{|n| n.downcase.gsub(" ", "_")}
    end

  end
end
