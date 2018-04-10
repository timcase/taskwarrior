require 'test_helper'

class ProjectFactoryTest < Minitest::Test

  def setup
    @tw = Taskwarrior.open(taskrc_path, task_data_dir)
    @factory = Taskwarrior::ProjectFactory.new(@tw.execute("projects"))
    @projects = @factory.to_a
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
    assert_equal 'Song-Vintage-Rare', @projects.last.slug
  end

  def test_array_returns_correct_last_project_extended_name
    assert_equal 'Song.Vintage.Rare', @projects.last.extended_name
  end

  def test_to_a_when_passed_empty_array
    @factory = Taskwarrior::ProjectFactory.new([]).to_a
  end

end
