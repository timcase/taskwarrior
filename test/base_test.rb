require 'test_helper'

class BaseTest < Minitest::Test

  def setup
    @tw = Taskwarrior.open(task_data_dir)
  end

  def test_all_returns_array_with_correct_count
    assert_equal 8, @tw.all.count
  end

  def test_all_returns_array_with_tasks
    assert_kind_of Taskwarrior::Task, @tw.all.first
  end

  def test_projects_returns_array_with_correct_count
    assert_equal 2, @tw.projects.count
  end

  def test_tags_returns_array_with_correct_count
    assert_equal 31, @tw.tags.count
  end

  def test_project_sets_filter
    @tw.project('Work')
    assert_equal 'project:Work', @tw.filter
  end

  def test_tag_sets_filter
    @tw.tag('thisweek')
    assert_equal '+thisweek', @tw.filter
  end

  # def test_project_filter_returns_results
  #   assert_equal 0, @tw.tag('thisweek').all
  # end

end
