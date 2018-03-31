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
      add_slug
    end

    def to_app_format
      project_rows.map{|r| Project::RawStringFormatter.new(r)}
    end

    def add_slug
      projects = to_app_format.map{|p| [p.name, p.nesting_level]}
      @match = Project::SlugGenerator.new(projects)
      @match.add
    end
  end
end
