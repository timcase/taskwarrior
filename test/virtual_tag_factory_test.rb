require 'test_helper'

class VirtualTagFactoryTest < Minitest::Test

  def setup
    @tw = Taskwarrior.open(task_data_dir)
    @factory = Taskwarrior::VirtualTagFactory.new
    @tags = @factory.to_a
  end

  def test_to_a_returns_right_count
    assert_equal 30, @tags.count
  end

  def test_to_a_returns_first_tag
    assert_equal 'BLOCKED', @tags.first.name
  end

  def test_to_a_returns_last_tag
    assert_equal 'LATEST', @tags.last.name
  end

end
