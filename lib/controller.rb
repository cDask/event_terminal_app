require_relative 'events'
require_relative 'errors/invalid_command_error'
require_relative 'errors/event_already_exists'

class EventController
  attr_reader :events

  def initialize
    @events = Events.new
  end

  def create_event(name)
    raise EventAlreadyExists unless @events.retrieve(name).nil?

    @events.add_event(name)
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
      create_event(information)
    when 'SPEAKER'
      create_speaker(information)
    when 'TALK'
      create_talk(information)
    else
      raise InvalidCommandError
    end
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
end
