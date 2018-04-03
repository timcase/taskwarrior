require 'test_helper'

class VirtualTagTest < Minitest::Test

  def setup
    @tw = Taskwarrior.open(task_data_dir)
  end

  def test_name_is_chomped
    assert_equal 'BLOCKED', Taskwarrior::VirtualTag.new(["BLOCKED\n", ""]).name
  end

  def test_description_is_chomped
    assert_equal 'description',
      Taskwarrior::VirtualTag.new(["", "description\n"]).description
  end


end
