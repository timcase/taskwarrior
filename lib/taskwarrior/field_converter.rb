require 'shellwords'

module Taskwarrior
  class FieldConverter
    def initialize(fields_hash)
      @fields_hash = fields_hash
    end

    def to_tw_args
      @fields_hash.map{|k, v| "\"#{k}:#{escape(v)}\""}.join(" ")
    end

    private

    def escape(value)
      value.gsub(/([^A-Za-z0-9_\s\-.,:'\[\]\(\)\/@\n])/, "\\\\\\1")
    end
  end
end
