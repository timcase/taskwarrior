require "test_helper"

class TestProjectSlugGenerator < Minitest::Test

  def setup
    @projects1 = [["Dance", 0], ["House", 0], ["Indoors", 1], ["Kitchen", 2],
                  ["Outdoors", 1], ["Work", 0], ["Indoors", 1], ["Outdoors", 1]]
    @projects2 = ["Dance", "House.Indoors.Kitchen", "House.Outdoors",
                  "Work.Indoors", "Work.Outdoors"]
    @gen = Taskwarrior::Project::SlugGenerator.new(@projects1, @projects2)
  end

  def test_candidates
    expected = ["Dance", "House", "House-Indoors", "House-Indoors-Kitchen",
                "House-Outdoors","Work", "Work-Indoors", "Work-Outdoors"]
    assert_equal expected,  @gen.candidates
  end

  def test_add_slugs
    res =  @gen.add
    assert_equal ["Dance", 0, "Dance"], res[0]
    assert_equal ["House", 0, "House"], res[1]
    assert_equal ["Indoors", 1, "House-Indoors"], res[2]
    assert_equal ["Kitchen", 2, "House-Indoors-Kitchen"], res[3]
    assert_equal ["Outdoors", 1, "House-Outdoors"], res[4]
    assert_equal ["Work", 0, "Work"], res[5]
    assert_equal ["Indoors", 1, "Work-Indoors"], res[6]
    assert_equal ["Outdoors", 1, "Work-Outdoors"], res[7]
  end

end
