require 'test_helper'

class ProjectsTest < Minitest::Test

  def setup
    @tw = Taskwarrior.open(task_data_dir)
    @projects = Taskwarrior::Projects.new(@tw.execute("projects")).projects
  end

  def test_returns_array
    assert_kind_of Array, @projects
  end

  def test_array_count_is_correct
    assert_equal 3, @projects.count
  end

  def test_array_item_is_project
    assert_kind_of Taskwarrior::Project, @projects.first
  end

  def test_array_returns_correct_first_project
    assert_equal '(none)', @projects.first.name
  end

  def test_array_returns_correct_last_project
    assert_equal 'Song', @projects.last.name
  end

end
