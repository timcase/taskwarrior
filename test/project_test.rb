require 'test_helper'

class ProjectTest < Minitest::Test


  def test_project_returns_name
    project = Taskwarrior::Project.new(none_fixture)
    assert_equal "(none)", project.name
  end

  def test_project_returns_task_count
    project = Taskwarrior::Project.new(none_fixture)
    assert_equal 10, project.task_count
  end

  def none_fixture
    "(none)      10"
  end

end
