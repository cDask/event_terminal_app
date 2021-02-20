require 'json'

class Events
  attr_accessor :events

  def initialize
    @events = load_data
  end

  def add_event(title)
    @events[title] = {}
  end

  def retrieve(title)
    @events[title]
  end

  def load_data
    JSON.parse(File.read('./data/event_data.json'))
  rescue StandardError
    File.open('./data/event_data.json', 'w') do |f|
      f.write({}.to_json)
    end
    retry
  end

  def save_data
    File.write('./data/event_data.json', @events.to_json, mode: 'w')
  end
end
