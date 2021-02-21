require_relative '../lib/event_controller'
require_relative '../lib/errors/event_already_exists'

describe EventController do
  subject {
    EventController.new('./data/test.json')
  }

  it 'should be an instance of Event Controller' do
    expect(subject).to be_a EventController
  end

  context 'Command processing' do
    it 'should return an error if first input word is not CREATE or PRINT' do
      expect { subject.process_command(['TEST']) }.to raise_error(InvalidCommandError)
    end

    it 'should return an error if the second input word is invalid' do
      test_command = %w[CREATE TEST]
      expect { subject.process_command(test_command) }.to raise_error(InvalidCommandError)
    end
  end

  context 'Create an event' do
    it 'should have an events object' do
      expect(subject.events).to be_a Events
    end

    it 'should be able to add an event' do
      event_name = 'Test Events'
      subject.create_event(event_name)
      expect(subject.events.events.length).to eq(1)
    end

    it 'should check if an event already exists before adding it' do
      event_name = 'Test Event'
      subject.create_event(event_name)
      expect { subject.create_event(event_name) }.to raise_error(EventAlreadyExists)
    end
  end

  context 'Speaker' do
    it 'should add a speaker' do
      speaker_name = 'Test Speaker'
      subject.create_speaker(speaker_name)
      expect(subject.events.speakers).to include(speaker_name)
    end

    it 'should raise an error if speaker already exists' do
      speaker_name = 'Test Speaker'
      subject.create_speaker(speaker_name)
      expect { subject.create_speaker(speaker_name) }.to raise_error(SpeakerAlreadyExists)
    end
  end

  context 'Talks' do
    before(:each) do
      subject.create_event('test_event')
      subject.create_speaker('test_speaker')
    end
    let(:talk_information) { ['test_event', 'Test Talk', '9:00am', '10:00am', 'test_speaker'] }

    it 'should check that event exists' do
      talk_information[0] = 'no_event'
      expect { subject.create_talk(talk_information) }.to raise_error(InvalidTalkInput)
    end

    it 'should check that speaker exists' do
      talk_information[4] = 'no_speaker'
      expect { subject.create_talk(talk_information) }.to raise_error(InvalidTalkInput)
    end

    it 'should check that start time and finish time are in right format' do
      talk_information[2] = 'not_time_format'
      expect { subject.create_talk(talk_information) }.to raise_error(InvalidTalkInput)
    end

    it 'should check that start time is before finish time' do
      talk_information[2] = '10:00am'
      talk_information[3] = '9:00am'
      expect { subject.create_talk(talk_information) }.to raise_error(InvalidTalkInput)
    end

    it 'should check that start time is not within another talk' do
      subject.create_talk(['test_event', 'Test Talk 2', '8:00am', '9:30am', 'test_speaker'])
      expect { subject.create_talk(talk_information) }.to raise_error(InvalidTalkInput)
    end

    it 'should check that finish time is not within another talk' do
      subject.create_talk(['test_event', 'Test Talk 2', '8:00am', '9:30am', 'test_speaker'])
      expect { subject.create_talk(talk_information) }.to raise_error(InvalidTalkInput)
    end

    it 'should check that another event is not taking place within the start and finish time of a talk' do
      subject.create_talk(['test_event', 'Test Talk 2', '9:10am', '9:30am', 'test_speaker'])
      expect { subject.create_talk(talk_information) }.to raise_error(InvalidTalkInput)
    end
  end

  describe 'Methods' do
    context 'convert_time method' do
      it 'should convert time from HH:MMam to time object' do
        expect(subject.convert_time('10:00pm')).to eq(Time.new(2021, 0o2, 21, 22, 0o0))
      end
    end

    context 'format command method' do
      it 'should add command enclosed by quotations' do
        expect(subject.format_command(['test', "'hello", "world'"])).to eq(['test', 'hello world'])
      end
    end
  end
end
