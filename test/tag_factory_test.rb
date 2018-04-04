require 'test_helper'

class TagFactoryTest < Minitest::Test

  def setup
    @tw = Taskwarrior.open(taskrc_path, task_data_dir)
    @factory = Taskwarrior::TagFactory.new(@tw.execute("tags"))
    @tags = @factory.to_a
 end

  def test_returns_array
    assert_kind_of Array, @tags
  end

  def test_array_count_is_correct
    assert_equal 1, @tags.count
  end

  def test_array_item_is_project
    assert_kind_of Taskwarrior::Tag, @tags.first
  end

  def test_array_returns_correct_last_project
    assert_equal 'thisweek', @tags[0].name
  end

  def test_array_returns_correct_last_project
    assert_equal "3", @tags[0].task_count
  end

  def test_to_a_when_passed_empty_array
    @factory = Taskwarrior::TagFactory.new([]).to_a
  end

end
