require 'test_helper'

class ReportTest < Minitest::Test

  def setup
    @tw = Taskwarrior.open(taskrc_path, task_data_dir)
    @report = Taskwarrior::Report.new(@tw.execute("list"))
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

  def test_column_delimiter_returns_string
    assert_kind_of String, @report.column_delimiter
  end

  def test_column_delimiter_returns_correctly
    #This test will change based on the terminal it's run on
    # assert_equal 'A2A1A4A1A25A1A8A1A32A1A4', @report.column_delimiter
  end

  def test_rows_returns_array
    assert_kind_of Array, @report.rows
  end

  def test_rows_returns_correct_count
    assert_equal 18, @report.rows.count
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
    assert_match /\d\.\d\d/, @report.rows.first[5]
  end

  def test_concats_overflow_rows
    s = 'The rain in Spain falls mainly on the plain, the '
    s += 'quick brown'
    assert_equal s, @report.rows[6][4]
  end

end
