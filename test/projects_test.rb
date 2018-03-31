require 'test_helper'

class ProjectsTest < Minitest::Test

  def setup
    @tw = Taskwarrior.open(task_data_dir)
    @instance = Taskwarrior::Projects.new(@tw.execute("projects"),
                                          @tw.execute("_projects"))
    @projects = @instance.projects
  end

  def test_p_rows
    assert_equal '', @instance.send(:project_rows)

  end

  def test_project_rows
    assert_equal '', @instance.send(:_project_rows)

  end

  def test_returns_array
    assert_kind_of Array, @projects
  end

  def test_array_count_is_correct
    assert_equal 9, @projects.count
  end

  def test_array_item_is_project
    assert_kind_of Taskwarrior::Project, @projects.first
  end

  def test_array_returns_correct_first_project
    assert_equal '(none)', @projects.first.name
  end

  def test_array_returns_correct_last_project
    assert_equal 'Rare', @projects.last.name
  end

  def test_array_returns_correct_last_project_slug
    assert_equal 'Song.Vintage.Rare', @projects.last.slug
  end

end
