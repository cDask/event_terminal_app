require 'json'

class Events
  attr_reader :events, :speakers

  def initialize
    response = load_data
    @events = response['events']
    @speakers = response['speakers']
  end

  def add_event(title)
    @events[title] = []
  end

  def retrieve(title)
    @events[title]
  end

  def load_data
    JSON.parse(File.read('./data/event_data.json'))
  rescue StandardError
    File.open('./data/event_data.json', 'w') do |f|
      f.write({ events: {}, speakers: [] }.to_json)
    end
    retry
  end

  def save_data
    File.write('./data/event_data.json', { events: @events, speakers: @speakers }.to_json, mode: 'w')
  end

  def check_speaker?(name)
    @speakers.include?(name)
  end

  def add_speaker(name)
    @speakers << name
  end

  def add_talk(event_name, talk_data)
    @events[event_name] << talk_data
  end

end
