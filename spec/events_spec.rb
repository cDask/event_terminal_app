require_relative '../lib/events'
require 'json'

describe 'Events' do
  before(:each) do
    @data = Events.new
  end

  it 'should be an instance of Data' do
    expect(@data).to be_a Events
  end

  it 'should have no data' do
    expect(@data.events).to eq({})
  end

  it 'should add an event to the event hash' do
    event_title = 'Main Event'
    @data.add_event(event_title)
    expect(@data.events[event_title]).to eq({})
  end

  it 'should be able to find a specific event' do
    event_title = 'Test Event'
    @data.add_event(event_title)
    expect(@data.retrieve(event_title)).to eq({})
  end

  context 'JSON storage' do
    it 'should read the information in a json data file' do
      data = JSON.parse(File.read('./data/event_data.json'))
      expect(@data.events).to include(data)
    end

    # it 'should write to json data file at the end of the program' do
    #   @data.add_event('Test Event')
    #   @data.save_data
    #   test_data = JSON.parse(File.read('./data/event_data.json'))
    #   expect(test_data['Test Event']).to eq({})
    # end
  end
end
