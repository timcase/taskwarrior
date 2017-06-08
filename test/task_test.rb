require 'test_helper'

class TaskTest < Minitest::Test

  def setup
    @tw = Taskwarrior.open(task_data_dir)
    @data_rows = @tw.export
  end

  def test_instance_variables
    t = Task.new(@data_rows.first)
    assert_equal 1, t.id
    assert_equal '3abc44b9-afbd-468b-9d06-25dfd1619457', t.uuid
    assert_equal 0, t.urgency
    assert_equal 'Shoot the moon', t.description
    assert_nil t.end
    assert_equal '20170607T064758Z', t.entry
    assert_equal '20170607T064758Z', t.modified
    assert_equal 'pending', t.status
    assert_nil t.project


  end


end
