require_relative 'lib/event_controller'

app = EventController.new('./data/event_data.json')
app.run_app
app.close
