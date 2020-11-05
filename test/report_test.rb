require 'test_helper'

class ReportTest < Minitest::Test

  def setup
    @tw = Taskwarrior.open(
      taskrc_path,
      task_data_dir,
      bin_path: File.join(File.dirname(__FILE__), 'bin/task')
    )
    @report = Taskwarrior::Report.new(@tw.execute("list"))
    @completed_report = Taskwarrior::Report.new(@tw.execute("completed"))
  end

  def test_tasks
    assert_kind_of Array, @report.tasks
  end

  def test_tasks_return_task_objects
    assert_kind_of Taskwarrior::Task, @report.tasks.first
  end

  def test_column_names_returns_array
    assert_kind_of Array, @report.column_names
  end

  def test_column_names_returns_correct_count
    assert_equal 6, @report.column_names.count
  end

  def test_column_names_returns_correct_first_column_name
    assert_equal 'id', @report.column_names.first
  end

  def test_column_names_return_correct_last_column_name
    assert_equal 'urg', @report.column_names.last
  end

  def test_column_delimiter_returns_array
    assert_kind_of Array, @report.column_delimiter
  end

  def test_column_delimiter_returns_correctly
    assert_equal [2, 1, 4, 1, 25, 1, 8, 1, 182, 1, 4], @report.column_delimiter
  end

  def test_rows_returns_array
    assert_kind_of Array, @report.rows
  end

  def test_rows_returns_correct_count
    assert_equal 19, @report.rows.count
  end

  def test_rows_returns_first_row_as_array
    assert_kind_of Array, @report.rows.first
  end

  def test_rows_returns_first_row_with_column_count_equal_to_columns_names_count
    assert_equal @report.column_names.count, @report.rows.first.count
  end

  def test_rows_returns_expected_values
    assert_equal '6', @report.rows.first[0]
    assert_match /\d(w|m|y|d)/, @report.rows.first[1]
    assert_equal '', @report.rows.first[2]
    assert_equal 'thisweek', @report.rows.first[3]
    assert_equal 'Redesign website', @report.rows.first[4]
    assert_match /\d\.\d/, @report.rows.first[5]
  end

  def test_concats_overflow_rows
    s = 'The rain in Spain falls mainly on the plain, the '
    s += 'quick brown fox jumps over the lazy dog'
    assert_equal s, @report.rows[6][4]
  end

  def test_case_name
    line = @completed_report.data_rows.first
    cd = @completed_report.extract_column_data(line)
    assert_equal '-', cd[0]
    assert_equal '581df788', cd[1]
    assert_equal '2018-11-26', cd[2]
    assert_equal '2018-11-28', cd[3]
    assert_equal 'H', cd[5]
    assert_equal 'WingTask.App', cd[6]
    assert_equal 'launch', cd[7]
    assert_equal "Can’t remove go from having a task with tag “in” to tag empty, “in” remains", cd[8]
  end

end
