require_relative "../lib/controller"
require_relative "../lib/errors/event_already_exists"

describe "Event Controller" do
  before(:each) do
    @controller = EventController.new
  end

  it "should be an instance of Event Controller" do
    expect(@controller).to be_a EventController
  end
  
  it "should have an events object" do
    expect(@controller.events).to be_a Events
  end

  it "should be able to add an event" do
    event_name = "Test Events"
    @controller.add_event(event_name)
    expect(@controller.events.events.length).to eq(1)
  end

  it "should check if an event already exists before adding it" do
    event_name  = "Test Event"
    @controller.add_event(event_name)
    pp @controller.events
    expect{@controller.add_event(event_name)}.to raise_error(EventAlreadyExists)
  end
end