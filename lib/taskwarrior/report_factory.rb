module Taskwarrior
  class ReportFactory

    def to_a
      split_reports.map {|row| Taskwarrior::Report.new(nil, row.first,
                                                        row.last)}
    end

    def read_reports
      File.readlines(File.join(File.dirname(__FILE__), 'raw_reports'))
    end

    def split_reports
      read_reports.map{|row| row.split(/\s{2,}/)}
    end
  end

end
