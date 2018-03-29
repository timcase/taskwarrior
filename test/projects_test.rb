require 'test_helper'

class ProjectsTest < Minitest::Test

  def setup
    @tw = Taskwarrior.open(task_data_dir)
    @projects = Taskwarrior::Projects.new(@tw.execute("projects"))
  end

  def test_first_project
    assert_equal ',d', @projects.rows
  end

  def test_last_project
  end

  def test_projecs_count
  end

end
