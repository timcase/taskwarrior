require 'test_helper'

class ReportTest < Minitest::Test

  def setup
    @tw = Taskwarrior.open(task_data_dir)
    @report = Taskwarrior::Report.new(@tw.execute("list"))
  end

  def test_column_names_returns_array
    assert_kind_of Array, @report.column_names
  end

  def test_column_names_returns_correct_count
    assert_equal 6, @report.column_names.count
  end

  def test_column_names_returns_correct_first_column_name
    assert_equal 'ID', @report.column_names.first
  end

  def test_column_names_return_correct_last_column_name
    assert_equal 'Urg', @report.column_names.last
  end

  def test_column_delimiter_returns_string
    assert_kind_of String, @report.column_delimiter
  end

  def test_column_delimiter_returns_correctly
    assert_equal 'A2A1A3A1A7A1A8A1A51A1A4', @report.column_delimiter
  end

  def test_rows_returns_array
    assert_kind_of Array, @report.rows
  end

  def test_rows_returns_correct_count
    assert_equal 12, @report.rows.count
  end

  def test_rows_returns_first_row_as_array
    assert_kind_of Array, @report.rows.first
  end

  def test_rows_returns_first_row_with_column_count_equal_to_columns_names_count
    assert_equal @report.column_names.count, @report.rows.first.count
  end

end
