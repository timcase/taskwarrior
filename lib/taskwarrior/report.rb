module Taskwarrior
  class Report

    def initialize(data)
      @data = data
    end

    def column_names
      @data[1].split("\s")
    end

    def column_delimiter
      sizes = @data[2]
      @data[2].split("\s").map{|dashes| "A#{dashes.strip.length}"}.join("A1")
    end

    def rows
      rows = @data[3..@data.length - 1].map do |line|
        if line.length > 1
          line.unpack(column_delimiter).select.each_with_index{|_, i| i.even?}
        end
      end
    end

  end
end
      # File.write('list_output', res)

      # names = res[1]
      # names = names.split("\s")
      # sizes = res[2]
      # sizes =  sizes.split("\s").map{|dashes| dashes.length}
      # sizes
      # # raise sizes.inspect
      # field_pattern= 'A2A1A5A1A7A1A8A1A49A1A4'
      # res[10].unpack(field_pattern)

      # rows = res[3..res.length - 1].map do |line|
      #   if line.length > 1
      #     line.unpack(field_pattern)
      #   end
      # end
      # rows.first
