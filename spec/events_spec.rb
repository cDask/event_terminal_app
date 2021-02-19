require_relative "../lib/events"

describe 'Events' do
  before(:each) do
    @data = Events.new
  end

  it "should be an instance of Data" do
    expect(@data).to be_a Events
  end
  
  it "should have no data" do
    expect(@data.events).to eq({})
  end

  it "should add an event to the event hash" do
    event_title = "Main Event"
    @data.add_event(event_title)
    expect(@data.events[event_title]).to eq({})
  end

  it "should be able to find a specific event" do
    event_title = "Test Event"
    @data.add_event(event_title)
    expect(@data.retrieve(event_title)).to eq({})
  end
end