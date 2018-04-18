module Taskwarrior
  class Context
    attr_reader :name, :definition, :active, :slug

    def initialize(row)
      @name = row[0]
      @definition = row[1]
      @active = row[2] == "yes" ? true : false
      @slug = @name
    end

  end

end
