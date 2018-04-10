require 'test_helper'
require 'ostruct'

class InformationTest < Minitest::Test

  def setup
    @tw = Taskwarrior.open(taskrc_path, task_data_dir)
    @factory = Taskwarrior::InfoTaskFactory.new(@tw.execute("information"))
  end

  def test_task_index_ranges
    ranges = @factory.task_index_ranges
    assert_equal 18, ranges.count
    assert_kind_of OpenStruct, ranges.first
    assert_equal 1, ranges.first.start
    assert_equal 15, ranges.first.end
  end

  def test_tasks
    assert_equal 18, @factory.tasks.count
    assert_equal 'ID', @factory.tasks.first.names.first
    assert_equal '1', @factory.tasks.first.values.first
    assert_equal 'Unclog sink', @factory.tasks.first.description
  end

end
