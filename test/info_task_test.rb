require 'test_helper'

class InfoTest < Minitest::Test

  def setup
    @tw = Taskwarrior.open(
      taskrc_path,
      task_data_dir,
      bin_path: File.join(File.dirname(__FILE__), 'bin/task')
    )
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

  def test_array_does_something
    i = 1
    b = ["id", "description", "", "", "status"]
    c = [6, "this", "is", "correct", "pending"]
    d = b[(i+1)..(b.count - 1)]
    e = d.find_index{|e| e.length > 1}

    assert_equal ["this", "is", "correct"], c[i..(e+1)]

  end

  def test_description_with_long_text
    factory = Taskwarrior::InfoTaskFactory.new(@tw.execute("information"))
    range = OpenStruct.new(start: 17, end: 31)
    info_task = Taskwarrior::InfoTask.new(factory.lines_from_range(range))
    s = "The quick brown dog jumps over the lazy dog. Spinx of black quartz, judge my vow. Two driven jocks help fax big quiz. Go forward and make another line for me and do it very soon."

    assert_equal s, info_task.description

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

  def test_fields_returns_hash
    assert_instance_of Hash, @info_task.fields
  end

  def test_fields_keys_are_names_matched_with_values
    assert_equal @info_task.values[0], @info_task.fields[@info_task.names[0]]
  end

end
