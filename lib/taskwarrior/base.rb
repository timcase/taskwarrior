require 'json'
require 'open3'
require 'shellwords'

module Taskwarrior
  class RunCommandError < ::StandardError; end
  class IneligibleForMarkingDone < ::StandardError; end
  class IneligibleForDeleting < ::StandardError; end

  class Base
    attr_reader :taskrc_path, :data_location, :config

    def self.open(taskrc_path, data_location, options)
      self.new(taskrc_path, data_location, options)
    end

    def initialize(taskrc_path, data_location, options)
      @taskrc_path = taskrc_path
      @data_location = data_location
      @config = Config.new(options)
      @taskwarrior_config_overrides = [
        "rc:#{taskrc_path}/taskrc",
        "rc.data.location=#{data_location}",
        "rc.confirmation=off",
        "rc.defaultwidth=0",
      ]
      @filter = []
      @fields = []
    end

    def add_filter(criteria)
      @filter << criteria.to_s.shellescape
    end

    def sync
      command('sync')
    end

    def sync_init
      command('sync init')
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
      @filter = add_filter("+#{name}")
      json_export
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

    def completed(fields: nil, json:false)
      if json
        @filter = add_filter('status:completed')
        json_export
      else
        get_report("completed", fields)
      end
    end

    def information
      @taskwarrior_config_overrides << info_dateformat_config
      Taskwarrior::InfoTaskFactory.new(execute("information")).tasks
    end

    def list(fields: nil, json: false)
      if json
        @filter = add_filter('status:pending')
        json_export
      else
        get_report("list", fields)
      end
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
      @taskwarrior_config_overrides << "rc.search.case.sensitive:no"
      add_filter('status:pending')
      add_filter(qry)
      ids = information.map(&:id)
      add_filter(ids.join(","))
      list(json: true)
    end

    def done(id)
      @filter = add_filter(id)
      command('done')
    end

    def delete(id)
      @filter = add_filter(id)
      command('delete')
    end

    def modify(id, fields)
      @filter = add_filter(id)
      command('modify', FieldConverter.new(fields).to_tw_args)
      info(id)
    end

    def add(fields)
      result = command('add', FieldConverter.new(fields).to_tw_args)
      id = result.scan(/\d+/).first
      info(id)
    end

    def log(fields)
      result = command('log', FieldConverter.new(fields).to_tw_args)
      id = result.scan(/\d+/).first
      info(id)
    end

    def find(id)
      @filter = add_filter(id)
      export
    end

    def json_export
      command('export')
    end

    def export
      JSON.parse(command('export'), object_class: OpenStruct)
    end

    def import(fields_json)
      result = command('import -', [], stdin_data: fields_json)
      id = result.scan(/[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}/).first
      # info(id)
      @filter = add_filter("#{id}")
      json_export
    end

    def info(id)
      @taskwarrior_config_overrides << info_dateformat_config
      c = ["#{id}", "info"].join(" ")
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

    def command(cmd, task_opts=[], capture3_opts = {})
      t_opts = [task_opts].flatten.join(' ')
      e = [config.bin_path]
      e << @taskwarrior_config_overrides.join(' ')
      e << filter
      e << cmd
      e << t_opts
      e << configured_fields
      e = e.join(" ")
      @fields = []
      @filter = []
      puts e if config.verbose || config.dry_run
      capture3(e, capture3_opts) unless config.dry_run
    end

    def capture3(cmd, capture3_opts)
      stdout, stderr, status = Open3.capture3(cmd, capture3_opts)
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
        elsif stdout =~ /is neither pending nor waiting/
          raise Taskwarrior::IneligibleForMarkingDone.new(stdout.chomp)
        elsif stdout =~ /is not deletable/
          raise Taskwarrior::IneligibleForDeleting.new(stdout.chomp)
        else
          msg = [stdout, stderr.chomp.split("\n").last].join(" ").inspect
          raise Taskwarrior::RunCommandError.new(msg)
        end
      end
    end

    def command_lines(cmd)
      cmd.encode('UTF-8', :invalid => :replace).split("\n")
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
