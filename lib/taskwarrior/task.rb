require 'time'

module Taskwarrior
  class Task
    attr_reader :id, :uuid, :urgency
    attr_accessor :description, :end, :entry, :modified, :status, :project

    def initialize(data)
      @id = data['id']
      @uuid = data['uuid']
      @urgency = data['urgency']
      @description = data['description']
      @end = data['end'] ? Time.parse(data['end']) : nil
      @entry = data['entry'] ? Time.parse(data['entry']) : nil
      @modified = data['modified'] ? Time.parse(data['modified']) : nil
      @status = data['status']
      @project = data['project']
    end
  end
end
