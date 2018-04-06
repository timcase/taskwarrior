require 'json'
require 'open3'
module Taskwarrior
  class RunCommandError < ::StandardError; end
  class Base
    attr_reader :taskrc_path, :data_location

    def self.config
      return @@config ||= Config.new
    end

    def self.open(taskrc_path, data_location)
      self.new(taskrc_path, data_location)
    end

    def initialize(taskrc_path, data_location)
      @taskrc_path = taskrc_path
      @data_location = data_location
      @filter = []
    end

    def add_filter(criteria)
      @filter << criteria
    end

    def filter
      @filter.join(" ")
    end

    def sync
      command('sync')
    end

    def project(name)
      Taskwarrior::Report.new(execute("project:#{name} list"))
    end

    def projects
      Taskwarrior::ProjectFactory.new(execute("projects")).to_a
    end

    def tags
      Taskwarrior::TagFactory.new(execute("tags")).to_a
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

    def commands
      Taskwarrior::Report.new(execute("commands"))
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
      Taskwarrior::ReportFactory.new.to_a
    end

    def virtual_tags
      Taskwarrior::VirtualTagFactory.new.to_a
    end

    def unblocked
      Taskwarrior::Report.new(execute("unblocked"))
    end

    def _aliases
      execute('_aliases')
    end

    def columns
      execute('_columns')
    end

    def _commands
      execute('_commands')
    end

    def _config
      execute('_config')
    end

    def _context
      execute('_context')
    end

    def _get
      execute('_get')
    end

    def _ids
      execute('_ids')
    end

    def _projects
      execute('_projects')
    end

    def _reviewed
      execute('_reviewed')
    end

    def _show
      execute('_show')
    end

    def _tags
      execute('_tags')
    end

    def _udas
      execute('_udas')
    end

    def _unique
      execute('_unique')
    end

    def _urgency
      execute('_urgency')
    end

    def _uuids
      execute('_uuids')
    end

    def _version
      execute('_version')
    end

    def _zshattributes
      execute('_zshattributes')
    end

    def _zshcommands
      execute('_zshcommands')
    end

    def _zshids
      execute('_zshids')
    end

    def _zshuuids
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

		def find(id)
			@filter = add_filter(id)
			export
		end

    def export
      JSON.parse(command('export'), object_class: OpenStruct)
    end

    def info(id)
      command_lines(command("#{id} info"))
    end

    def contexts
      Taskwarrior::ContextFactory.new(execute("context list")).to_a
    end

    def set_context(context)
      execute("context #{context}")
    end

    private

    def command(cmd, opts=[])
      opts = [opts].flatten.join(' ')
      e = ["task #{filter} #{cmd} #{opts}"]
      e << "rc:#{self.taskrc_path}/taskrc"
      e << "rc.data.location=#{self.data_location}"
      e << "rc.confirmation=off"
      e = e.join(" ")
      @filter = []
      stdout, stderr, status = Open3.capture3(e)
      if status.success?
        return stdout.chomp
      else
        if stderr =~ /No matches\./
          return ""
        elsif stdout =~ /No projects\./
          return ""
        elsif stderr =~ /No tags\./
          return ""
        else
          raise Taskwarrior::RunCommandError.new(stderr.chomp)
        end
      end
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
