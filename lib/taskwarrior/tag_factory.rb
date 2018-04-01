module Taskwarrior
  class TagFactory

    attr_reader :data

    def initialize(tags)
      @tags = tags
    end

    def to_a
      to_app_format.map{|f| Tag.new([f.name, f.slug, f.task_count])}
    end
    # def to_a
    #   projects_arr_of_arr.map{|arr| Project.new(arr)}
    # end

    def project_rows
      @tags[3..@tags.length]
    end

    # def projects_arr_of_arr
    #   counts = to_app_format.map{|p| p.task_count}
    #   add_slug.map.with_index do |r, i|
    #     r << counts[i]
    #   end
    # end

    def to_app_format
      project_rows.map{|r| Project::RawStringFormatter.new(r)}
    end

    # def add_slug
    #   projects = to_app_format.map{|p| [p.name, p.nesting_level]}
    #   @gen = Project::SlugGenerator.new(projects)
    #   @gen.add
    # end
  end
end
