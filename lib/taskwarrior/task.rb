class Task
  attr_reader :id, :uuid, :urgency
  attr_accessor :description, :end, :entry, :modified, :status, :project

  def initialize(data)
    @id = data['id']
    @uuid = data['uuid']
    @urgency = data['urgency']
    @description = data['description']
    @end = data['end']
    @entry = data['entry']
    @modified = data['modified']
    @status = data['status']
    @project = data['project']
  end
end
