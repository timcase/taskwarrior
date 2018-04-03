require 'test_helper'

class InitTest < Minitest::Test

  def test_open
    c = '/home/jdoe'
    d = '/home/jdoe/.task'
    t = Taskwarrior.open(c, d)
    assert_equal t.taskrc_path, c
    assert_equal t.data_location, d
  end

end
