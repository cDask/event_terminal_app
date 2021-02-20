class EventView
 def initialize; end

 def print_error(error_message)
  puts "- #{error_message} -"
 end

 def request_command
    puts 'Please enter your command:'
    gets.strip.split
 end

 def confirm_creation(name, data_type)
  puts '-' * 10
  puts "#{data_type}: #{name} CREATED"
  puts '-' * 10
 end
end