module Taskwarrior::Base::Report
    def column_names
      @data[1].split("\s").map{ |name| name.downcase }
    end

    def delimiter_row
      @data[2]
    end

    def column_delimiter
      delimiter_row.split("\s").map{|dashes| "A#{dashes.strip.length}"}.join("A1")
        .split("A").reject{|c| c.empty?}.map(&:to_i)
    end

    def rows
      data_rows.map do |line|
        extract_column_data(line)
      end.compact[0..-3]
    end

    def data_rows
      @data.any? ? @data[3..@data.length - 1] : []
    end

    def extract_column_data(line)
      l = line.dup
      res = column_delimiter.each_with_index.inject([]) do |arr, (delimiter, i)|
        data = l.slice!(0, delimiter).strip
        arr << data unless i.odd?
        arr
      end
      res
    end

    def concat_column_data_from_next_row(current_row, i)
      next_row = extract_column_data(@data[i + 1])
      current_row.zip(next_row).map{|z| z.join(" ").strip}
    end

end
