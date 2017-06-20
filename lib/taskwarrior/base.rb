require 'json'
require 'open3'
module Taskwarrior
  class Base
    attr_reader :data_location

    def self.config
      return @@config ||= Config.new
    end

    def self.open(data_location)
      self.new(data_location)
    end

    def initialize(data_location)
      @data_location = data_location
      @filter = []
    end

    def add_filter(criteria)
      @filter << criteria
    end

    def filter
      @filter.join(" ")
    end

    def project(name)
      Taskwarrior::Report.new(execute("project:#{name} list"))
    end

    def tag(name)
      Taskwarrior::Report.new(execute("+#{name} list"))
    end

    def active
      Taskwarrior::Report.new(execute("active"))
    end

    def all
      Taskwarrior::Report.new(execute("all"))
    end

    def blocked
      Taskwarrior::Report.new(execute("blocked"))
    end

    def blocking
      Taskwarrior::Report.new(execute("blocking"))
    end

    def completed
      Taskwarrior::Report.new(execute("completed"))
    end

    def list
      Taskwarrior::Report.new(execute("list"))
    end

    def long
      Taskwarrior::Report.new(execute("long"))
    end

    def ls
      Taskwarrior::Report.new(execute("ls"))
    end

    def minimal
      Taskwarrior::Report.new(execute("minimal"))
    end

    def newest
      Taskwarrior::Report.new(execute("newest"))
    end

    def next
      Taskwarrior::Report.new(execute("next"))
    end

    def oldest
      Taskwarrior::Report.new(execute("oldest"))
    end

    def overdue
      Taskwarrior::Report.new(execute("overdue"))
    end

    def ready
      Taskwarrior::Report.new(execute("ready"))
    end

    def recurring
      Taskwarrior::Report.new(execute("recurring"))
    end

    def reports
      Taskwarrior::Report.new(execute("reports"))
    end

    def unblocked
      Taskwarrior::Report.new(execute("unblocked"))
    end

    def aliases
      execute('_aliases')
    end

    def columns
      execute('_columns')
    end

    def commands
      execute('_commands')
    end

    def config
      execute('_config')
    end

    def context
      execute('_context')
    end

    def get
      execute('_get')
    end

    def ids
      execute('_ids')
    end

    def projects
      execute('_projects')
    end

    def reviewed
      execute('_reviewed')
    end

    def show
      execute('_show')
    end

    def tags
      execute('_tags')
    end

    def udas
      execute('_udas')
    end

    def unique
      execute('_unique')
    end

    def urgency
      execute('_urgency')
    end

    def uuids
      execute('_uuids')
    end

    def version
      execute('_version')
    end

    def zshattributes
      execute('_zshattributes')
    end

    def zshcommands
      execute('_zshcommands')
    end

    def zshids
      execute('_zshids')
    end

    def zshuuids
      execute('_zshuuids')
    end

    def execute(cmd)
      command_lines(command(cmd))
    end

    def search(qry)
      Taskwarrior::Report.new(execute("/#{qry}/"))
    end

    def done(id)
      @filter = add_filter(id)
      command('done')
    end

    def delete(id)
      @filter = add_filter(id)
      command('delete')
    end

    def modify(id, description, options={})
      @filter = add_filter(id)
      arr_opts = []
      arr_opts << "description:'#{description}'"
      command('modify', arr_opts)
    end

    def add(description, options = {})
      arr_opts = []
      arr_opts << description
      command('add', arr_opts)
    end

    def export
      JSON.parse(command('export'))
    end

    def info(id)
      command_lines(command("#{id} info"))
    end

    private
    def command(cmd, opts=[])
      opts = [opts].flatten.join(' ')
      e = "task #{filter} #{cmd} #{opts} rc.data.location=#{self.data_location} rc.confirmation=off"
      @filter = []
      stdout, stderr, status = Open3.capture3(e)
      stdout.chomp
    end

    def command_lines(cmd)
      op = cmd.encode("UTF-8", "binary", {
        :invalid => :replace,
        :undef => :replace
      })
      op.split("\n")
    end

  end

end
