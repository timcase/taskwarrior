require 'test_helper'

class BaseTest < Minitest::Test

  def setup
    @tw = Taskwarrior.open(task_data_dir)
  end

  def test_all_returns_array_with_correct_count
    assert_equal 9, @tw.all.rows.count
  end

  def test_all_returns_array_with_tasks
    assert_kind_of Array, @tw.all.rows.first
  end

  def test_lists_returns_a_report_object
    assert_instance_of Taskwarrior::Report, @tw.list
  end

  def test_projects_returns_array_with_correct_count
    assert_equal 2, @tw.projects.count
  end

  def test_tags_returns_array_with_correct_count
    assert_equal 31, @tw.tags.count
  end

  def test_project_returns_a_report_object
    assert_instance_of Taskwarrior::Report, @tw.project('Dance')
  end

  def test_project_returns_correct_number_of_rows
    assert_equal 1, @tw.project('Dance').rows.count
  end

  def test_tag_returns_correct_number_of_rows
    assert_equal 3, @tw.tag('thisweek').rows.count
  end

  def test_add_creates_a_new_task
    start_count = @tw.all.rows.count
    @tw.add("Go to the movies")
    assert_equal start_count + 1, @tw.all.rows.count
  end

  def test_info_returns_an_array_of_lines
    assert_kind_of Array, @tw.info(1)
    assert_equal '', @tw.info(1).last
  end



end
