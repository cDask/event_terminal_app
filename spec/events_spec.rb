require_relative "../lib/events"

describe 'Data' do
  before(:each) do
    @data = Events.new
  end

  it "should be an instance of Data" do
    expect(@data).to be_a Events
  end
  
  it "should have no data" do
    expect(@data.events).to eq({})
  end

  it "should add an event" do
    expect(@data.add_event("Main Event")).to eq("Main Event")
  end

  it "should add an event to the event hash" do
    @data.add_event("Main Event")
    expect(@data.events.last).to eq({})
  end
end