module Taskwarrior
  class Projects

    attr_reader :data

    def initialize(projects, _projects)
      @projects = projects
      @_projects = _projects
    end

    def to_app_format
      rows.map{|r| Project.new(r)}
    end

    private

    def rows
      project_rows.zip(_project_rows)
    end

    def project_rows
      @projects[3..@projects.length-3]
    end

    def _project_rows
      # @_projects
      @_projects.unshift("(none)")

    end
  end
end
