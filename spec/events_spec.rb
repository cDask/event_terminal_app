require_relative '../lib/events'
require 'json'

describe Events do
  subject { Events.new('./data/test.json') }

  it 'should be an instance of Data' do
    expect(subject).to be_a Events
  end

  it 'should have no data' do
    expect(subject.events).to eq({})
  end
  context 'Events' do
    it 'should add an event to the event hash' do
      event_title = 'Main Event'
      subject.add_event(event_title)
      expect(subject.events[event_title]).to eq([])
    end
  
    it 'should be able to find a specific event' do
      event_title = 'Test Event'
      subject.add_event(event_title)
      expect(subject.retrieve(event_title)).to eq([])
    end
  end

  context 'Speakers' do
    it 'should add a speaker to speaker array' do
      speaker_name = 'John'
      subject.add_speaker(speaker_name)
      expect(subject.speakers).to include(speaker_name)
    end
  end

  context 'Talks' do
    it 'should add talk to event' do
      subject.add_event('test_event')
      subject.add_speaker('test_speaker')
      subject.add_talk('test_event', {'title' => 'test_talk', 'speaker' => 'test_speaker', 'start_time' => Time.now, 'finish_time' => Time.now + 100})
      expect(subject.events['test_event'].last['title']).to eq('test_talk')
    end

    it 'should sort talks in order of time' do
      subject.add_event('test_event')
      subject.add_speaker('test_speaker')
      subject.add_talk('test_event', {'title' => 'test_talk', 'speaker' => 'test_speaker', 'start_time' => Time.new(2021,02,21,9,00), 'finish_time' => Time.new(2021,02,21,10,00)})
      test_talk = {'title' => 'test_talk', 'speaker'=> 'test_speaker', 'start_time'=> Time.new(2021,02,21,8,00), 'finish_time' => Time.new(2021,02,21,8,50)}
      subject.add_talk('test_event', test_talk)
      expect(subject.events['test_event'][0]).to eq(test_talk)
    end
  end

  context 'JSON storage' do
    it 'should read the information in a json data file' do
      data = JSON.parse(File.read('./data/test.json'))
      expect(subject.events).to include(data['events'])
    end

    # it 'should write to json data file at the end of the program' do
    #   subject.add_event('Test Event')
    #   subject.save_data
    #   test_data = JSON.parse(File.read('./data/event_data.json'))
    #   expect(test_data['Test Event']).to eq({})
    # end
  end
end
