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

  context 'Speaker' do
    it 'should add a speaker' do
      speaker_name = 'Test Speaker'
      @controller.create_speaker(speaker_name)
      expect(@controller.events.speakers).to include(speaker_name)
    end

    it 'should raise an error if speaker already exists' do
      speaker_name = 'Test Speaker'
      @controller.create_speaker(speaker_name)
      expect { @controller.create_speaker(speaker_name)}.to raise_error(SpeakerAlreadyExists)
    end
  end

  context 'Talks' do 
    before(:each) do
      @controller.create_event('test_event')
      @controller.create_speaker('test_speaker')
    end
    let(:talk_information) {['test_event', 'Test Talk', '9:00am', '10:00am', 'test_speaker']}

    it 'should check that event exists' do
      talk_information[0] = 'no_event'
      pp @controller.events.retrieve('no_event')
      expect{@controller.create_talk(talk_information)}.to raise_error(InvalidTalkInput)
    end
    
    it 'should check that speaker exists' do
      pp talk_information
      talk_information[4] = 'no_speaker'
      expect{@controller.create_talk(talk_information)}.to raise_error(InvalidTalkInput)
    end

    it 'should check that start time and finish time are in right format' do
      talk_information[2] = 'not_time_format'
      expect{@controller.create_talk(talk_information)}.to raise_error(InvalidTalkInput)
    end
    
    it 'should check that start time is before finish time' do
      talk_information[2] = '10:00am'
      talk_information[3] = '9:00am'
      expect{@controller.create_talk(talk_information)}.to raise_error(InvalidTalkInput)
    end

    xit 'should check that start time is not within another talk' do
      talk_information[2] = 'not_time_format'
      expect{@controller.create_talk(talk_information)}.to raise_error(InvalidTalkInput)
    end

    xit 'should check that finish time is not within another talk' do
      talk_information[2] = 'not_time_format'
      expect{@controller.create_talk(talk_information)}.to raise_error(InvalidTalkInput)
    end

    xit 'should check that another event is not taking place within the start and finish time of a talk' do
      talk_information[2] = 'not_time_format'
      expect{@controller.create_event(talk_information)}.to raise_error(InvalidTalkInput)
    end
  end

  describe 'Methods' do
    context 'convert_time method' do
      it 'should convert time from HH:MMam to time object' do
        expect(@controller.convert_time('10:00pm')).to eq(Time.new(2021,02,21,22,00))
      end
    end
  end
end
