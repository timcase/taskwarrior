module Taskwarrior::Base::Report
    def column_names
      @data[1].split("\s").map{ |name| name.downcase }
    end

    def column_delimiter
      sizes = @data[2]
      @data[2].split("\s").map{|dashes| "A#{dashes.strip.length}"}.join("A1")
    end

    def rows
      data_rows.map do |line|
        cd = extract_column_data(line)
        next if current_row_is_overflow?(line)
        if next_row_is_overflow?(line)
          cd = concat_column_data_from_next_row(cd, @data.index(line))
        end
        cd
      end.compact[0..-2]
    end

    def data_rows
      @data.any? ? @data[3..@data.length - 1] : []
    end

    def next_row_is_overflow?(current_row)
      next_row = @data[@data.index(current_row) + 1]
      if next_row
        row_is_overflow?(extract_column_data(next_row))
      else
        false
      end
    end

    def current_row_is_overflow?(current_row)
      row_is_overflow?(extract_column_data(current_row))
    end

    def row_is_overflow?(row)
        first_column = row.first
        first_column.empty?
    end

    def extract_column_data(line)
        line.unpack(column_delimiter).select.each_with_index{|_, i| i.even?}
          .map{|r| r.strip}
    end

    def concat_column_data_from_next_row(current_row, i)
      next_row = extract_column_data(@data[i + 1])
      current_row.zip(next_row).map{|z| z.join(" ").strip}
    end

end
