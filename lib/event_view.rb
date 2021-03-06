class EventView
  def initialize; end

  def print_error(error_message)
    puts "- #{error_message} -"
  end

  def request_command
    puts 'Please enter your command:'
    gets.strip
  end

  def confirm_creation(name, data_type)
    puts '-' * 10
    puts "#{data_type}: #{name} CREATED"
    puts '-' * 10
  end

  def print_event(event)
    puts '-' * 20
    if event.empty?
      puts 'This event does not have any talks'
    else
      event.each do |talk|
        puts "#{talk['start_time'].strftime('%I:%M%p')} - #{talk['finish_time'].strftime('%I:%M%p')}"
        puts "\t #{talk['title']} presented by #{talk['speaker']}"
      end
    end
    puts '-' * 20
  end
end
