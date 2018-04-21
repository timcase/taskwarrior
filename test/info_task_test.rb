require 'test_helper'

class InfoTest < Minitest::Test

  def setup
    @tw = Taskwarrior.open(taskrc_path, task_data_dir)
    @factory = Taskwarrior::InfoTaskFactory.new(@tw.execute("information"))
    @range = OpenStruct.new(start: 1, end: 15)
    @info_task = Taskwarrior::InfoTask.new(@factory.lines_from_range(@range))
  end

  def test_uuid_extracted
    assert_equal "3abc44b9-afbd-468b-9d06-25dfd1619457", @info_task.uuid
  end

  def test_description_extracted
    assert_equal "Shoot the moon", @info_task.description
  end

  def test_status_extracted
    assert_equal "Pending", @info_task.status
  end

  def test_project_extracted
    assert_nil @info_task.project
  end

  def test_tags_extracted
    assert_equal [], @info_task.tags
  end

  def test_due_extracted
    assert_nil @info_task.due
  end

  def test_names_array_count
    assert_equal 7, @info_task.names.count
  end

  def test_values_array_count_matches_name
    assert_equal @info_task.names.count, @info_task.names.count
  end

  def test_data_array_count_matches_names_and_values
    assert_equal @info_task.names.count, @info_task.data.count
  end

end
