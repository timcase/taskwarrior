require 'test_helper'

class ReportFactoryTest < Minitest::Test

  def setup
    @tw = Taskwarrior.open(taskrc_path, task_data_dir)
    @factory = Taskwarrior::ReportFactory.new
    @reports = @factory.to_a
  end

  def test_count
    assert_equal 14, @reports.count
  end

  def test_first
    assert_equal "active", @reports.first.name
  end

  def test_last
    assert_equal 'waiting', @reports.last.name
  end

end
