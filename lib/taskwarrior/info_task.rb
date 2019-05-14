require 'ostruct'

module Taskwarrior
  class InfoTask
    include Base::Report

    attr_reader :uuid, :description, :project, :due, :wait, :start, :end_date,
      :scheduled, :until, :priority, :recurrence, :status, :tags, :fields

    def initialize(rows)
      @rows = rows
      @uuid = extract_value("uuid")
      @description = extract_value("description")
      @project = extract_value("project")
      @due = extract_value("due")
      @wait = extract_value("waiting_until")
      @start = extract_value("start")
      @end_date = extract_value("end")
      @scheduled = extract_value("scheduled")
      @until = extract_value("until")
      @priority = extract_value("priority")
      @recurrence = extract_value("recurrence")
      @status = extract_value('status')
      @tags = extract_value("tags")
      @tags = @tags.nil? ? [] : @tags.split("\s")
      @fields = data.to_h
    end

    def names
      @names ||= data_rows.map{|r| r.first}
    end

    def values
      @values ||= data_rows.map{|r| r.last.encode('UTF-8', invalid: :replace,
                                      undef: :replace).gsub('�', '').strip }
    end

    def data
      @data ||= names.zip(values)
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

    def delimiter_row
      @rows[1]
    end

    def split_rows
      @rows[2..@rows.length-1].map{|r| extract_column_data(r)}
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
