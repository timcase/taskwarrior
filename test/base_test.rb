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

    @tw = Taskwarrior.open(
      taskrc_path,
      task_data_dir,
      bin_path: File.join(File.dirname(__FILE__), 'bin/task')
    )
  end

  def test_all_returns_array_with_correct_count
    assert_equal 20, @tw.all.rows.count
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
    assert_equal 32, @tw._tags.count
  end

  def test_project_returns_a_report_object
    assert_instance_of Taskwarrior::Report, @tw.project('Dance')
  end

  def test_search_returns_a_report_object
    assert_instance_of Taskwarrior::Report, @tw.search('moon')
    assert_equal 1, @tw.search('moon').rows.count
  end

  def test_search_with_space_between_words
    assert_equal 1, @tw.search('the moon').rows.count
  end


  def test_project_returns_correct_number_of_rows
    assert_equal 1, @tw.project('Dance').rows.count
  end

  def test_tag_returns_correct_number_of_tasks
    tag_json = @tw.tag('thisweek')
    assert_json tag_json
    parsed = JSON.parse(tag_json)
    assert_equal 3, parsed.count
  end

  def test_tag_returns_correct_number_of_tasks
    tag_json = @tw.tag('READY')
    assert_json tag_json
    parsed = JSON.parse(tag_json)
    assert_equal 19, parsed.count
  end

  def test_add_with_quoted_string
    start_count = @tw.all.rows.count
    args = {"description"=>"Watch Schindler's list",
            "project"=>"", "tags"=>"", "due"=>"",
            "start"=>"", "end"=>"", "scheduled"=>"",
            "until"=>"", "wait"=>"", "recur"=>"", "priority"=>""}
    @tw.add(args)
    assert_equal start_count + 1, @tw.all.rows.count
  end

  def test_add_with_brackets
    args = {"description"=>"[test] Write test",
            "project"=>"", "tags"=>"", "due"=>"",
            "start"=>"", "end"=>"", "scheduled"=>"",
            "until"=>"", "wait"=>"", "recur"=>"", "priority"=>""}
    res = @tw.add(args)
    assert_equal '[test] Write test', res.description
  end

  def test_add_with_double_quotes
    args = {"description"=>"Watch \"My Father's brother\""}

    res = @tw.add(args)
    assert_equal "Watch \"My Father's brother\"",  res.description
  end

  def test_add_creates_a_task
    start_count = @tw.all.rows.count
    args = {"description"=>"Go to the movies",
            "project"=>"MyProject", "tags"=>"", "due"=>"",
            "start"=>"", "end"=>"", "scheduled"=>"",
            "until"=>"", "wait"=>"", "recur"=>"", "priority"=>""}
    info = @tw.add(args)
    assert_equal start_count + 1, @tw.all.rows.count
    assert_equal 'Go to the movies', @tw.find(info.uuid).first.description
    assert_equal 'MyProject', @tw.find(info.uuid).first.project
  end


  def test_add_returns_an_info_task
    res = @tw.add(description: "Go to the movies")
    assert_kind_of Taskwarrior::InfoTask, res
  end

  def test_import_creates_a_task
    start_count = @tw.all.rows.count
    args_json = {"description"=>"Go to the movies"}.to_json
    json = @tw.import(args_json)
    result = JSON.parse(json, object_class: OpenStruct).first
    assert_equal start_count + 1, @tw.all.rows.count
    assert_equal 'Go to the movies', @tw.find(result.uuid).first.description
  end

  def test_import_returns_json
    args_json = {"description"=>"Go to the movies"}.to_json
    json = @tw.import(args_json)
    assert_json json
    results = JSON.parse(json)
    assert_kind_of Array, results
    assert_equal 1, results.count
  end

  def test_import_with_nonlatin_characters
    args_json = {"description"=>"สวัสดี"}.to_json
    json = @tw.import(args_json)
    result = JSON.parse(json, object_class: OpenStruct).first
    assert_equal "สวัสดี",  @tw.find(result.uuid).first.description
  end

  def test_update_task_via_import
    start_count = @tw.all.rows.count
    task = @tw.find(1).first
    args_json = {description: 'New Description', uuid: task.uuid}.to_json
    json = @tw.import(args_json)
    result = JSON.parse(json, object_class: OpenStruct).first
    assert_equal "New Description",  @tw.find(result.uuid).first.description
    assert_equal start_count, @tw.all.rows.count
  end

  def test_modify_mods_a_task
    assert_equal '1', @tw.all.rows.last.first
    assert_equal 'Shoot the moon', @tw.all.rows.last.last
    @tw.modify(1, { description: 'Watch the Simpsons', project: 'TV' })
    assert_equal 'Watch the Simpsons', @tw.all.rows.last.last
    assert_equal 'TV', @tw.all.rows.last[6]
  end

  def test_modify_returns_info_task
    res = @tw.modify(1, { description: 'Watch the Simpsons', project: 'TV' })
    assert_instance_of Taskwarrior::InfoTask, res
    assert_equal 'Watch the Simpsons', res.description
  end

  def test_modify_can_delete_a_field_by_modding_it_with_empty_string
    res = @tw.modify(1, { tags: 'in'})
    assert_equal ['in'], res.tags
    res = @tw.modify(1, { tags: ''})
    assert_equal [], res.tags
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
    tag_json = @tw.tag('BLOCKED')
    assert_json tag_json
    parsed = JSON.parse(tag_json)
    assert_equal 0, parsed.count
  end

  def test_contexts_returns_correct_count
    assert_equal 4, @tw.contexts.count
  end

  def test_contexts_returns_zero_when_none
    @tw.contexts.each do |c|
      @tw.delete_context(c.name)
    end

    assert_equal 0, @tw.contexts.count
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

  def test_info_with_iso_formatted_date
    year = Time.now.year + 1
    @tw.modify('3abc44b9-afbd-468b-9d06-25dfd1619457', { due: "#{year}-05-01" })
    res = @tw.info('3abc44b9-afbd-468b-9d06-25dfd1619457')
    assert_equal "#{year}-05-01T00:00:00", res.due
  end

  def test_log_creates_completed_task
    # start_count = @tw.completed.tasks.count
    # @tw.log(description: "Go to the movies")
    # assert_equal start_count + 1, @tw.completed.tasks.count
  end

  def test_information_with_status_pending
    @tw.add_filter("status:pending")
    assert_equal 19, @tw.information.count
  end

  def test_information_with_search
    @tw.add_filter("/the moon/")
    assert_equal 1, @tw.information.count
  end

  def test_bad_encoding_does_not_raise_error
    @tw.add_filter("status:pending")
    #assert nothing raised
    @tw.information.last
    assert true
  end

  def test_information_with_search_and_status_pending
    @tw.add_filter("/the moon/ status:pending")
    assert_equal 1, @tw.information.count
  end

  def test_all_without_fields_config
    @tw.execute("1 start")
    assert_nil @tw.active.tasks.first.uuid
    refute_nil @tw.active(fields: [:uuid]).tasks.first.uuid
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

  def test_list_report_has_no_issues_with_wrapping
    desc ="this task description is deliberately intended to be longer than eighty characters"
    @tw.add(description: desc)
    tasks = @tw.newest.tasks
    assert_equal desc, tasks.first.description
  end

  def test_json_export
    assert_respond_to @tw, :json_export
    json_string = @tw.json_export
    assert_json json_string
    parsed = JSON.parse(json_string)
    assert_equal 20, parsed.count
  end

  def test_list_as_json
    assert_respond_to @tw, :list
    json_string = @tw.list(json: true)
    assert_kind_of String, json_string
    assert_json json_string
    parsed = JSON.parse(json_string)
    assert_equal 19, parsed.count
  end

  def test_completed_as_json
    assert_respond_to @tw, :completed
    json_string = @tw.completed(json: true)
    assert_json json_string
    parsed = JSON.parse(json_string)
    assert_equal 1, parsed.count
  end

  def test_all_reports
    reports = @tw.reports
    reports.each do |r|
      report = @tw.send(r.name)
      if report.tasks.any?
        task = report.tasks.first
        assert_respond_to task, :id, "Failure on '#{r.name}' report"
        assert_respond_to task, :description, "Failure on '#{r.name}' report"
        assert_equal Encoding::UTF_8, task.description.encoding
      end
    end
  end

  def assert_json(json)
    JSON.parse(json)
    assert true
  rescue JSON::ParserError => e
    assert false, "String is not valid json"
  end
end
