require 'shellwords'

module Taskwarrior
  class FieldConverter
    def initialize(fields_hash)
      @fields_hash = fields_hash
    end

    def to_tw_args
      nonempty_fields.map{|k, v| "\"#{k}:#{escape(v)}\""}.join(" ")
    end

    private

    def nonempty_fields
      @fields_hash.select{|k, v|  !v.strip.empty?}
    end

    def escape(value)
      value.gsub(/\"/, "\"")
      # value.gsub(/([^A-Za-z0-9_\s\-.,:'\/@\n])/, "\\\\\\1")
    end
  end
end
