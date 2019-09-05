require 'test_helper'
require 'ostruct'

class InfoTaskFactoryTest < Minitest::Test

  def setup
    @tw = Taskwarrior.open(taskrc_path, task_data_dir)
    @factory = Taskwarrior::InfoTaskFactory.new(@tw.execute("information"))
  end

  def test_task_index_ranges
    ranges = @factory.task_index_ranges
    assert_equal 20, ranges.count
    assert_kind_of OpenStruct, ranges.first
    assert_equal 1, ranges.first.start
    assert_equal 14, ranges.first.end
  end

  def test_tasks
    assert_equal 20, @factory.tasks.count
    assert_equal 'ID', @factory.tasks.first.names.first
    assert_equal '1', @factory.tasks.first.values.first
    assert_equal 'Shoot the moon', @factory.tasks.first.description
    assert_equal "Can’t remove go from having a task with tag “in” to tag empty, “in” remains", @factory.tasks.last.description
    assert_equal 'WingTask.App', @factory.tasks.last.project
    assert_nil @factory.tasks.first.project
    assert_equal ['thisweek'], @factory.tasks[5].tags
    refute_nil @factory.tasks.first.uuid
    refute_nil @factory.tasks.last.uuid
  end

end
