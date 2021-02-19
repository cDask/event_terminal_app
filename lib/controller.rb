class EventController
  attr_reader :events

  def initialize
    @events = Events.new
  end

  def add_event(name)
    raise EventAlreadyExists if @events.retrieve(name) != nil
    @events.add_event(name)
  end
end