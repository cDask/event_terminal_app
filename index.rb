begin
  require_relative "lib/controller"
  app = EventController.new('./data/event_data.json')
  app.run_app
  app.close
  rescue => e
    puts e.message
 end


