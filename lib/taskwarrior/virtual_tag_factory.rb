module Taskwarrior
  class VirtualTagFactory

    def to_a
      @to_a ||= map_virtual_tags
    end

    def map_virtual_tags
      names.zip(descriptions).map{|vt| VirtualTag.new(vt)}
    end

    def tag_count
      raw_tags.length / 2
    end

    def names
      raw_tags.select.with_index { |_, i| i.even? }
    end

    def descriptions
      raw_tags.select.with_index { |_, i| i.odd? }
    end

    def raw_tags
      @raw_tags ||= read_tags
    end

    def read_tags
      File.readlines(File.join(File.dirname(__FILE__), 'raw_virtual_tags'))
    end

  end

end
