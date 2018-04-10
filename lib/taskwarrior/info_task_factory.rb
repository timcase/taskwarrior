module Taskwarrior
  class InfoTaskFactory

    def initialize(lines)
      @lines = lines
    end

    def task_index_ranges
      splits = @lines.map{|l| l.split("\s")}.map.with_index{|l, i| i if l.first =="Name"}.compact << (@lines.length + 3)
      splits = splits.map.with_index{|s, i| [s, (splits[i + 1])]}.reverse.drop(1).reverse.map{|pair| OpenStruct.new(start: pair.first, end: pair.last-3)}
      splits
    end

    def tasks
      task_index_ranges.map{|range|
        Taskwarrior::InfoTask.new(@lines[range.start..range.end])}
    end
  end
end
