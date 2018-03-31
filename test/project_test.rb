require 'test_helper'

class ProjectRawStringFormatterTest < Minitest::Test

  def test_project_returns_name
    project = Taskwarrior::Project::RawStringFormatter.new(none_fixture)
    assert_equal "(none)", project.name
  end

  def test_project_returns_name_when_nested
    project = Taskwarrior::Project::RawStringFormatter.new(nest1_fixture)
    assert_equal "nested", project.name
  end

  def test_project_returns_task_count
    project = Taskwarrior::Project::RawStringFormatter.new(none_fixture)
    assert_equal "10", project.task_count
  end

  def test_project_returns_nesting_level
    project = Taskwarrior::Project::RawStringFormatter.new(none_fixture)
    assert_equal 0, project.nesting_level
  end

  def test_project_returns_nesting_level_when_nested_a_level
    project = Taskwarrior::Project::RawStringFormatter.new(nest1_fixture)
    assert_equal 1, project.nesting_level
  end

  def test_project_returns_nesting_level_when_nested_2_levels
    project = Taskwarrior::Project::RawStringFormatter.new(nest2_fixture)
    assert_equal 2, project.nesting_level
  end

  def test_slug
    project = Taskwarrior::Project::RawStringFormatter.new(nest2_fixture)
    assert_equal "project.second.nested", project.slug
  end

  def none_fixture
    ["(none)      10", "(none)"]
  end

  def nest1_fixture
    ["  nested    15", "project.nested"]
  end

  def nest2_fixture
    ["    nested    15", "project.second.nested"]
  end

end
