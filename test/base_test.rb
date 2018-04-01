require 'test_helper'

class BaseTest < Minitest::Test

  def setup
    task_data_dir = '/tmp'
    ['backlog.data', 'completed.data', 'pending.data', 'undo.data'].each do |f|
      src = File.join([File.dirname(__FILE__), 'fixtures', 'task_data', f])
      dest = File.join([task_data_dir, f])
      FileUtils.cp(src, dest)
    end

    @tw = Taskwarrior.open(task_data_dir)
  end

  def test_all_returns_array_with_correct_count
    assert_equal 18, @tw.all.rows.count
  end

  def test_all_returns_array_with_tasks
    assert_kind_of Array, @tw.all.rows.first
  end

  def test_lists_returns_a_report_object
    assert_instance_of Taskwarrior::Report, @tw.list
  end

  def test_underscore_projects_returns_array_with_correct_count
    assert_equal 6, @tw._projects.count
  end

  def test_underscore_tags_returns_array_with_correct_count
    assert_equal 31, @tw._tags.count
  end

  def test_project_returns_a_report_object
    assert_instance_of Taskwarrior::Report, @tw.project('Dance')
  end

  def test_search_returns_a_report_object
    assert_instance_of Taskwarrior::Report, @tw.search('moon')
    assert_equal 1, @tw.search('moon').rows.count
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

  def test_modify_mods_a_task
    assert_equal '1', @tw.all.rows.last.first
    assert_equal 'Shoot the moon', @tw.all.rows.last.last
    @tw.modify(1, "Watch the Simpsons")
    assert_equal 'Watch the Simpsons', @tw.all.rows.last.last
  end

  def test_delete_marks_task_deleted
    assert_equal 'P', @tw.all.rows.last[1]
    @tw.delete(1)
    assert_equal 'D', @tw.all.rows.last[1]
  end

  def test_done_marks_task_done
    assert_equal 'P', @tw.all.rows.last[1]
    @tw.done(1)
    assert_equal 'C', @tw.all.rows.last[1]
  end

  def test_find_returns_a_single_record
    assert_equal 1, @tw.find(1).count
  end

  def test_find_returns_array_of_hashes
    assert_kind_of Array, @tw.find(1)
    assert_kind_of OpenStruct, @tw.find(1).first
  end

  def test_commands_is_instance_of_report
    assert_instance_of Taskwarrior::Report, @tw.commands
  end

  def test_underscore_commands_returns_array
    assert_instance_of Array, @tw._commands
  end

  def test_projects_returns_correct_count
    assert_equal 9, @tw.projects.count
  end

  def test_tags_returns_correct_count
    assert_equal 1, @tw.tags.count
  end

  def test_sync_exists
    assert_respond_to @tw, :sync
  end

end
