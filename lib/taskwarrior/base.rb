require 'json'
require 'open3'
module Taskwarrior
  class RunCommandError < ::StandardError; end
  class Base
    attr_reader :taskrc_path, :data_location, :exec_options

    def self.config
      return @@config ||= Config.new
    end

    def self.open(taskrc_path, data_location, exec_options)
      self.new(taskrc_path, data_location, exec_options)
    end

    def initialize(taskrc_path, data_location, exec_options)
      @taskrc_path = taskrc_path
      @data_location = data_location
      @exec_options = exec_options
      @filter = []
      @fields = []
    end

    def add_filter(criteria)
      @filter << criteria
    end

    def sync
      command('sync')
    end

    def project(name)
      Taskwarrior::Report.new(execute("project:#{name} list"))
    end

    def projects(fields: nil)
      Taskwarrior::ProjectFactory.new(execute("projects")).to_a
    end

    def tags
      Taskwarrior::TagFactory.new(execute("tags")).to_a
    end

    def tag(name)
      c = ["+#{name}", 'info', info_dateformat_config].join(" ")
      Taskwarrior::InfoTaskFactory.new(execute(c))
    end

    def info_dateformat_config
      "rc.dateformat.info:'Y-M-DTH:N:S'"
    end

    def virtual_tag(name)
      tag(name)
    end

    def active(fields: nil)
      get_report("active", fields)
    end


    def all(fields: nil)
      get_report("all", fields)
    end

    def blocked(fields: nil)
      get_report("blocked", fields)
    end

    def blocking(fields: nil)
      get_report("blocking", fields)
    end

    def commands
      Taskwarrior::Report.new(execute("commands"))
    end

    def completed(fields: nil)
      get_report("completed", fields)
    end

    def information
      c = ["information", info_dateformat_config].join(" ")
      Taskwarrior::InfoTaskFactory.new(execute(c)).tasks
    end

    def list(fields: nil)
      get_report("list", fields)
    end

    def long(fields: nil)
      get_report("long", fields)
    end

    def ls(fields: nil)
      get_report("ls", fields)
    end

    def minimal(fields: nil)
      get_report("minimal", fields)
    end

    def newest(fields: nil)
      get_report("newest", fields)
    end

    def next(fields: nil)
      get_report("next", fields)
    end

    def oldest(fields: nil)
      get_report("oldest", fields)
    end

    def overdue(fields: nil)
      get_report("overdue", fields)
    end

    def ready(fields: nil)
      get_report("ready", fields)
    end

    def recurring(fields: nil)
      get_report("recurring", fields)
    end

    def waiting(fields: nil)
      get_report("waiting", fields)
    end

    def reports
      Taskwarrior::ReportFactory.new.to_a
    end

    def virtual_tags
      Taskwarrior::VirtualTagFactory.new.to_a
    end

    def unblocked(fields: nil)
      get_report("unblocked", fields)
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

    def modify(id, updates, options={})
      @filter = add_filter(id)
      arr_opts = []
      arr_opts << updates
      command('modify', arr_opts)
      info(id)
    end

    def add(description, options = {})
      arr_opts = options.map{|k,v| "#{k}:'#{v}'"}
      arr_opts << description
      result = command('add', arr_opts)
      id = result.scan(/\d+/).first
      info(id)
    end

    def log(description, options = {})
      arr_opts = options.map{|k,v| "#{k}:'#{v}'"}
      arr_opts << description
      result = command('log', arr_opts)
      id = result.scan(/\d+/).first
      info(id)
    end

		def find(id)
			@filter = add_filter(id)
			export
		end

    def export
      JSON.parse(command('export'), object_class: OpenStruct)
    end

    def info(id)
      c = ["#{id}", "info", info_dateformat_config].join(" ")
      rows = command_lines(command(c))
      Taskwarrior::InfoTask.new(rows[1..rows.count-1])
    end

    def contexts
      Taskwarrior::ContextFactory.new(execute("context list")).to_a
    end

    def set_context(context)
      command("context #{context}")
    end

    def define_context(context, filter)
      command("context define #{context} #{filter}")
    end

    def delete_context(context)
      command("context delete #{context}")
    end

    private

    def command(cmd, opts=[])
      opts = [opts].flatten.join(' ')
      e = ["task #{filter} #{cmd} #{opts}"]
      e << "rc:#{self.taskrc_path}/taskrc"
      e << "rc.data.location=#{self.data_location}"
      e << "rc.confirmation=off"
      e << configured_fields
      e = e.join(" ")
      @fields = []
      @filter = []
      puts e if @exec_options.include?(:verbose)
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
        elsif stderr =~ /No contexts defined\./
          return ""
        else
          raise Taskwarrior::RunCommandError.new(stderr.chomp.split("\n").last)
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

    def get_report(name, fields)
      config_report_fields(name, fields) if fields
      Taskwarrior::Report.new(execute(name))
    end

    def config_report_fields(report, fields)
      f = fields.join(",")
      c = ["rc.report.#{report}.columns=#{f}",
           "rc.report.#{report}.labels=#{f}"
          ]
      @fields = c
    end

    def filter
      @filter.join(" ")
    end

    def configured_fields
      @fields.join(" ")
    end

  end

end
