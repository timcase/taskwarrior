require 'test_helper'

class FieldConverterTest < Minitest::Test
  def test_init
    fc = Taskwarrior::FieldConverter.new({"description"=>"empty bin",
                                          "project"=>"",
                                          "tags"=>"",
                             "due"=>"", "start"=>"", "end"=>"", "scheduled"=>"",
                             "until"=>"", "wait"=>"", "recur"=>"",
                             "priority"=>""})
    assert_instance_of Taskwarrior::FieldConverter, fc

  end

  def test_to_tw_args
    fc = Taskwarrior::FieldConverter.new({"description"=>"empty bin",
                                          "project"=>"Chores",
                                          "tags"=>"",
                             "due"=>"", "start"=>"", "end"=>"", "scheduled"=>"",
                             "until"=>"", "wait"=>"", "recur"=>"",
                             "priority"=>""})
    assert_kind_of String, fc.to_tw_args
    assert_match /\"description:empty bin\"/, fc.to_tw_args
    assert_match /\"project:Chores\"/, fc.to_tw_args
  end

  def test_to_tw_args_with_single_quote_in_field
    fc = Taskwarrior::FieldConverter.new({
      "description"=>"Watch Schindler's List",
                                          "project"=>"Movies",
                                          "tags"=>"",
                             "due"=>"", "start"=>"", "end"=>"", "scheduled"=>"",
                             "until"=>"", "wait"=>"", "recur"=>"",
                             "priority"=>""})
    assert_match /\"description:Watch Schindler's List\"/, fc.to_tw_args
  end

  def test_to_tw_args_with_double_quote_in_field
    fc = Taskwarrior::FieldConverter.new({
      "description"=>'Watch "Schindlers List"',
                                          "project"=>"Movies",
                                          "tags"=>"",
                             "due"=>"", "start"=>"", "end"=>"", "scheduled"=>"",
                             "until"=>"", "wait"=>"", "recur"=>"",
                             "priority"=>""})
    assert_match /\"description:Watch \\\"Schindlers List\\\"/, fc.to_tw_args
  end

end
