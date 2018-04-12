require "test_helper"

class TestProjectSlugGenerator < Minitest::Test

  def setup
    @projects = [["Dance", 0], ["House", 0], ["Indoors", 1], ["Kitchen", 2],
                  ["Outdoors", 1], ["Work", 0], ["Indoors", 1], ["Outdoors", 1]]
    @gen = Taskwarrior::Project::SlugGenerator.new(@projects)
  end

  def test_add_slugs
    res =  @gen.add
    assert_equal ["Dance", 0, "Dance", "Dance"], res[0]
    assert_equal ["House", 0, "House", "House"], res[1]
    assert_equal ["Indoors", 1, "House-Indoors", "House.Indoors"], res[2]
    assert_equal ["Kitchen", 2, "House-Indoors-Kitchen",
                  "House.Indoors.Kitchen"], res[3]
    assert_equal ["Outdoors", 1, "House-Outdoors", "House.Outdoors"], res[4]
    assert_equal ["Work", 0, "Work", "Work"], res[5]
    assert_equal ["Indoors", 1, "Work-Indoors", "Work.Indoors"], res[6]
    assert_equal ["Outdoors", 1, "Work-Outdoors", "Work.Outdoors"], res[7]
  end

end
