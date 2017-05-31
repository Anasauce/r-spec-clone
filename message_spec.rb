require_relative 'message'
require_relative 'fake_rspec'

describe Message do
  let(:long_string) { '0' to 150 }
  let(:message) = Message.new(nil, nil, long_string)
  let(:person) { Person.new(message) }
  describe '#initialize' do
    let(:long_string) { '1' * 150 }


    it 'truncates the body' do
      expect(message.body.length).to eq(140)
      # Subject.new(subject).to(EqualCondition.new(140))
      # expect(subject) <== subject
      # .to(condition)
      # make test fail or test pass
    end
  end
  # has to look up a method on it's parent

  it 'actually runs this code' do
    fail
  end
end
