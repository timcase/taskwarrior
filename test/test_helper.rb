$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'taskwarrior'

require 'minitest/autorun'

def taskwarrior_dir
  `pwd`.chomp
end

def test_dir
  File.join(taskwarrior_dir, 'test')
end

def fixtures_dir
  File.join(test_dir, 'fixtures')
end

def task_data_dir
  File.join(fixtures_dir, 'task_data')
end
