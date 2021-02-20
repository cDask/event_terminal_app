require_relative 'events'
require_relative 'errors/invalid_command_error'
require_relative 'errors/event_already_exists'
require_relative 'errors/speaker_already_exists'
require_relative 'errors/invalid_talk_input'

class EventController
  attr_reader :events

  def initialize
    @events = Events.new
  end

  def run_app
    command = process_arguments
    command ||= request_command
    process_command(command)
  end

  def process_command(command)
    first, second, *information = command
    case first
    when 'CREATE'
      check_data(second, information.length)
      process_create_command(second, information)
    when 'PRINT'
      raise InvalidCommandError if second != 'TALKS'

      print_event(information)
    else
      raise InvalidCommandError
    end
  end

  def process_create_command(command, information)
    case command
    when 'EVENT'
      create_event(information[0])
    when 'SPEAKER'
      create_speaker(information[0])
    when 'TALK'
      create_talk(information)
    else
      raise InvalidCommandError
    end
  end

  def create_event(name)
    raise EventAlreadyExists unless @events.retrieve(name).nil?

    @events.add_event(name)
  end

  def create_speaker(name)
    raise SpeakerAlreadyExists if @events.check_speaker?(name)

    @events.add_speaker(name)
  end

  def create_talk(talk_data)
    event_name, talk_name, start_time, finish_time, speaker = talk_data
    raise InvalidTalkInput, 'That event does not exist' if @events.retrieve(event_name).nil?
    raise InvalidTalkInput, 'That speaker does not exist' unless @events.speakers.include?(speaker)

    check_time(start_time, finish_time)
    @events.add_talk(event_name, { title: talk_name, start_time: start_time, finish_time: finish_time, speaker: speaker })
  end

  def check_time(start, finish)
    time_format = /b((1[0-2]|0?[1-9]):[0-5][0-9](am|pm))/
    raise InvalidTalkInput, 'Invalid time format must be HH:MMam/pm' unless start.match?(time_format) || finish.match?(time_format)

    start_time = convert_time(start)
    finish_time = convert_time(finish)
    if finish_time < start_time
      raise InvalidTalkInput, 'Start time has to be before finish time.'
    end
  end

  def convert_time(time)
    # time will be in HH:MMam/pm format
    time_array = time.split(/am|pm/)[0].split(':')
    hours = time.include?('pm') ? time_array[0].to_i + 12 : time_array[0].to_i
    minutes = time_array[1].to_i
    # Using 21-02-2021 as the place holder date
    Time.new(2021,02,21,hours,minutes)
  end

  def process_arguments
    return nil if ARGV.empty?

    arguments = *ARGV
    ARGV.clear
    arguments
  end

  def request_command
    puts 'Please enter your command:'
    gets.strip.split
  end

  def check_data(command, command_arguments)
    command_list = { 'TALK' => 5, 'EVENT' => 1, 'SPEAKER' => 1 }
    raise InvalidCommandError, 'Invalid number of arguments' if command_list[command] != command_arguments
  end

  def close
    @events.save_data
  end
end
