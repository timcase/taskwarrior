require 'test_helper'

class InformationTest < Minitest::Test

  def setup
    @tw = Taskwarrior.open(taskrc_path, task_data_dir)
    @report = Taskwarrior::Report.new(@tw.execute("information"))
  end

  def test_open
    assert_equal '', @report.rows
  end

end
