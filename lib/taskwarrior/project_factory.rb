module Taskwarrior
  class ProjectFactory

    attr_reader :data

    def initialize(projects, _projects)
      @projects = projects
      @_projects = _projects.unshift("(none)")
    end

    def to_a
      projects_arr_of_arr.map{|arr| Project.new(arr)}
    end

    private

    def rows
      project_rows.zip(_project_rows)
    end

    def project_rows
      @projects[3..@projects.length-3]
    end

    def _project_rows
       @_projects
    end

    def projects_arr_of_arr
      add_slug
    end

    def to_app_format
      projects = rows.map{|r| Project::RawStringFormatter.new(r)}
    end

    def add_slug
      projects = to_app_format.map{|p| [p.name, p.nesting_level]}
      @match = Project::SlugGenerator.new(projects, _project_rows)
      @match.add
    end
  end
end
