require 'test_helper'

class BaseTest < Minitest::Test

  def setup
    @tw = Taskwarrior.open(task_data_dir)
  end

  def test_export_returns_the_right_count
    assert_equal 5, @tw.export.count
  end

  def test_export_returns_hash
    first = @tw.export.first
    assert_kind_of Hash, first
  end

  def test_all_returns_array_with_correct_count
    assert_equal 5, @tw.all.count
  end

  def test_all_returns_array_with_tasks
    assert_kind_of Taskwarrior::Task, @tw.all.first
  end

end
