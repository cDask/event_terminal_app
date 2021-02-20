require_relative '../lib/events'
require 'json'

describe Events do
  before(:each) do
    @data = Events.new
  end

  it 'should be an instance of Data' do
    expect(@data).to be_a Events
  end

  it 'should have no data' do
    expect(@data.events).to eq({})
  end
  context 'Events' do
    it 'should add an event to the event hash' do
      event_title = 'Main Event'
      @data.add_event(event_title)
      expect(@data.events[event_title]).to eq([])
    end
  
    it 'should be able to find a specific event' do
      event_title = 'Test Event'
      @data.add_event(event_title)
      expect(@data.retrieve(event_title)).to eq([])
    end
  end

  context 'Speakers' do
    it 'should add a speaker to speaker array' do
      speaker_name = 'John'
      @data.add_speaker(speaker_name)
      expect(@data.speakers).to include(speaker_name)
    end
  end

  context 'Talks' do
    it 'should add talk to event' do
      @data.add_event('test_event')
      @data.add_speaker('test_speaker')
      @data.add_talk('test_event', {title: 'test_talk', speaker: 'test_speaker', start_time: Time.now, finish_time: Time.now + 100})
      expect(@data.events['test_event'].last[:title]).to eq('test_talk')
    end
  end

  context 'JSON storage' do
    it 'should read the information in a json data file' do
      data = JSON.parse(File.read('./data/event_data.json'))
      expect(@data.events).to include(data['events'])
    end

    # it 'should write to json data file at the end of the program' do
    #   @data.add_event('Test Event')
    #   @data.save_data
    #   test_data = JSON.parse(File.read('./data/event_data.json'))
    #   expect(test_data['Test Event']).to eq({})
    # end
  end
end
