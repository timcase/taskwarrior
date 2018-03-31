class Match

  def initialize(list1, list2)
    @list1 = list1
    @list2 = list2
  end

  def add_slugs
    @list1.map.with_index do |r, i|
      name = r.first
      nesting_level = r.last
      slug = find_slug(name, nesting_level, i)
      [name, nesting_level, slug]
    end
  end

  def list1_names
    @list1_names ||= @list1.map{ |r| r.first }
  end

  def parts(index)
    list1_names[0..index]
  end

  def candidates
    @list2.map{|r| r.split(".")}.map do |r|
      r.map{|e| r[0..r.index(e)].join(".")}
    end.flatten.uniq
  end

  def find_slug(target, nesting_level, target_index)
    parts(target_index).permutation.to_a.map{|e| e[0..nesting_level]}.
      select{|e| e.include?(target)}.map{|e| e.join(".")}.
      uniq.reverse.find{|pair| candidates.include?(pair)}
  end
end
