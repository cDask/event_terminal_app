begin
  require_relative "lib/controller"
  app = EventController.new
  app.run_app
  app.close
  rescue => e
    puts e.message
 end


