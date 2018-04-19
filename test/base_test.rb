require 'test_helper'

class BaseTest < Minitest::Test

  def setup
    taskrc_path = task_data_dir = '/tmp'
    ['backlog.data', 'completed.data', 'pending.data', 'undo.data'].each do |f|
      src = File.join([File.dirname(__FILE__), 'fixtures', 'task_data', f])
      dest = File.join([task_data_dir, f])
      FileUtils.cp(src, dest)
    end

    f = 'taskrc'
    src = File.join([File.dirname(__FILE__), 'fixtures', f])
    dest = File.join([taskrc_path, f])
    FileUtils.cp(src, dest)

    @tw = Taskwarrior.open(taskrc_path, task_data_dir)
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
    assert_equal 33, @tw._tags.count
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

  def test_add_returns_an_info_task
    res = @tw.add("Go to the movies")
    assert_kind_of Taskwarrior::InfoTask, res
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

  def test_virtual_tags_returns_correct_count
    assert_equal 30, @tw.virtual_tags.count
  end

  def test_sync_exists
    assert_respond_to @tw, :sync
  end

  def test_tag_when_no_matches
    assert_equal 0, @tw.tag("BLOCKED").rows.count
  end

  def test_contexts_returns_correct_count
    assert_equal 4, @tw.contexts.count
  end

  def test_set_context_changes_the_context
    assert_equal 'villa', @tw.contexts.last.name
    assert_equal false, @tw.contexts.last.active
    @tw.set_context "villa"
    assert_equal true, @tw.contexts.last.active
    @tw.set_context "none"
    assert_equal false, @tw.contexts.last.active
  end

  def test_projects_after_context_set
    @tw.set_context "forge"
    assert_equal [], @tw.execute('projects')
  end

  def test_tags_after_context_set
    @tw.set_context "forge"
    assert_equal [], @tw.execute('tags')
  end

  def test_reports
    assert_equal 14, @tw.reports.count
  end

  def test_info
    res = @tw.info('3abc44b9-afbd-468b-9d06-25dfd1619457')
    assert_equal 7, res.names.count
  end

  def test_information
    @tw.add_filter("status:pending")
    assert_equal 18, @tw.information.count
  end

  def test_define_context_creates_a_new_context
    count = @tw.contexts.count
    @tw.define_context("work", "+work")
    assert_equal count + 1, @tw.contexts.count
  end

  def test_define_context_creates_the_correct_name
    @tw.define_context("work", "+work")
    assert_equal 'work', @tw.contexts.last.name
  end

  def test_define_context_modifies_existing_context
    @tw.define_context("work", "+work")
    assert_equal '+work', @tw.contexts.last.definition
    @tw.define_context("work", "+outside")
    assert_equal '+outside', @tw.contexts.last.definition
  end

  def test_define_context_creates_the_correct_filter
    @tw.define_context("work", "+work")
    assert_equal '+work', @tw.contexts.last.definition
  end

  def test_delete_context_deletes_the_context
    assert @tw.contexts.any?{|c| c.name == 'forge'}
    @tw.delete_context('forge')
    assert @tw.contexts.none?{|c| c.name == 'forge'}
  end

  def test_all_reports
    reports = @tw.reports
    reports.each do |r|
      report = @tw.send(r.name)
      if report.tasks.any?
        task = report.tasks.first
        assert_respond_to task, :id, "Failure on '#{r.name}' report"
        assert_respond_to task, :description, "Failure on '#{r.name}' report"
      end
    end
  end
end
