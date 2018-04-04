module Taskwarrior
  class TagFactory

    attr_reader :data

    def initialize(tags)
      @tags = tags
    end

    def to_a
      to_app_format.map{|f| Tag.new([f.name, f.slug, f.task_count])}
    end

    def tag_rows
      @tags.any? ? @tags[3..@tags.length] : @tags
    end

    def to_app_format
      tag_rows.map{|r| Tag::RawStringFormatter.new(r)}
    end

  end
end
