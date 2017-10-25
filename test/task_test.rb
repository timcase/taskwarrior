require 'test_helper'

class TaskTest < Minitest::Test

  def test_instantiate_from_hash
    t = Taskwarrior::Task.new({'id': '121', 'description': 'task description'})
    assert_equal "121", t.id
    assert_equal "task description", t.description
  end
end
