require 'test_helper'

class InitTest < Minitest::Test

  def test_open
    d = '/home/jdoe/.task'
    t = Taskwarrior.open(d)
    assert_equal t.data_location, d
  end

end
