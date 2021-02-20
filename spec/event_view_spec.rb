require_relative '../lib/event_view'

describe EventView do
  subject { EventView.new }

  it 'should be able to output a error message' do
    expect { subject.print_error('Invalid input') }.to output("- Invalid input -\n").to_stdout
  end

  it 'should output an creation message' do
    expect { subject.confirm_creation('talk name', 'talk') }.to output("----------\ntalk: talk name CREATED\n----------\n").to_stdout
  end
end
