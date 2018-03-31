module Taskwarrior
  class Project::SlugGenerator

    def initialize(list)
      @list = list
    end

    def add
      res = @list.map.with_index do |r, i|
          arr = @list[0..i]
          arr = arr.reverse
          nl = r.last
          slug = nl.downto(0).map{|k| arr.rassoc(k).first}.reverse.join("-")
          @list[i] << slug
      end
    end

  end
end
