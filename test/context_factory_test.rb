require 'test_helper'

class TaskTest < Minitest::Test

  def setup
    @tw = Taskwarrior.open(taskrc_path, task_data_dir)
    @factory = Taskwarrior::ContextFactory.new(@tw.execute("context list"))
    @contexts = @factory.to_a
  end

  def test_first_context
    assert_equal 'dj', @contexts.first.name
  end

  def test_responds_to_a
    assert_respond_to @factory, :to_a
  end
end
