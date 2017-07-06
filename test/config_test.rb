require 'test_helper'

class ConfigTest < Minitest::Test
  def setup
    Taskwarrior::Base.class_variable_set :@@config, nil
  end

  def test_env_config
    assert_equal 'task', Taskwarrior::Base.config.binary_path
  end

  def test_env_config_from_block
    Taskwarrior.config do |c|
      c.binary_path = '/usr/bin/task'
    end
    assert_equal '/usr/bin/task', Taskwarrior::Base.config.binary_path
  end
end
