module Taskwarrior
  class Projects

    attr_reader :data

    def initialize(data)
      @data = data
    end

    def projects
      rows.map{|r| Project.new(r)}
    end

    private

    def rows
      @data[3..@data.length-3]
    end
  end
end
