require 'json'

class Events
  attr_reader :events, :speakers

  def initialize(path)
    @file_path = path
    response = load_data(path)
    @events = response['events']
    @speakers = response['speakers']
  end

  def add_event(title)
    @events[title] = []
  end

  def retrieve(title)
    @events[title]
  end

  def load_data(data_path)
    begin
      response = JSON.parse(File.read(data_path))
      response['events'].each do |_event, event_data|
        event_data.each do |talk|
          talk['start_time'] = Time.parse(talk['start_time'])
          talk['finish_time'] = Time.parse(talk['finish_time'])
        end
      end
      response
    rescue Errno::ENOENT => exception
      File.open(data_path, 'w') do |f|
        f.write({ events: {}, speakers: [] }.to_json)
      end
      retry
    end
  end

  def save_data
    File.write(@file_path, { events: @events, speakers: @speakers }.to_json, mode: 'w')
  end

  def check_speaker?(name)
    @speakers.include?(name)
  end

  def add_speaker(name)
    @speakers << name
  end

  def add_talk(event_name, talk_data)
    @events[event_name] << talk_data
    @events[event_name].sort! do |a, b|
      a['start_time'] <=> b['start_time']
    end
  end
end
