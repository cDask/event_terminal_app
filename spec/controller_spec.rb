require_relative '../lib/controller'
require_relative '../lib/errors/event_already_exists'

describe EventController do
  before(:each) do
    @controller = EventController.new
  end

  it 'should be an instance of Event Controller' do
    expect(@controller).to be_a EventController
  end

  context 'Command processing' do
    it 'should return an error if first input word is not CREATE or PRINT' do
      expect { @controller.process_command(['TEST']) }.to raise_error(InvalidCommandError)
    end

    it 'should return an error if the second input word is invalid' do
      test_command = %w[CREATE TEST]
      expect { @controller.process_command(test_command) }.to raise_error(InvalidCommandError)
    end
  end

  context 'Create an event' do
    it 'should have an events object' do
      expect(@controller.events).to be_a Events
    end

    it 'should be able to add an event' do
      event_name = 'Test Events'
      @controller.create_event(event_name)
      expect(@controller.events.events.length).to eq(1)
    end

    it 'should check if an event already exists before adding it' do
      event_name = 'Test Event'
      @controller.create_event(event_name)
      expect { @controller.create_event(event_name) }.to raise_error(EventAlreadyExists)
    end
  end
end
