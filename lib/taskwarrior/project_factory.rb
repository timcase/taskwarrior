module Taskwarrior
  class ProjectFactory

    attr_reader :data

    def initialize(projects)
      @projects = projects
    end

    def to_a
      projects_arr_of_arr.map{|arr| Project.new(arr)}
    end

    def project_rows
      @projects[3..@projects.length-3]
    end

    def projects_arr_of_arr
      counts = to_app_format.map{|p| p.task_count}
      add_slug.map.with_index do |r, i|
        r << counts[i]
      end
    end

    def to_app_format
      project_rows.map{|r| Project::RawStringFormatter.new(r)}
    end

    def add_slug
      projects = to_app_format.map{|p| [p.name, p.nesting_level]}
      @gen = Project::SlugGenerator.new(projects)
      @gen.add
    end
  end
end
