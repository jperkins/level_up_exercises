require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Overlord::Bomb do
  subject { Overlord::Bomb.new }

  describe '#new' do
    it 'returns an inactive bomb' do
      expect(subject).not_to be_active
    end

    it 'initializes itself to supplied parameters' do
      expect(Overlord::Bomb.new(:state => "activated")).to be_active
    end
  end

  describe '#process_code' do
    context 'when the bomb is inactive' do
      context 'when it receives a valid activation code' do
        it 'activates the bomb' do
          subject.process_code('1234')

          expect(subject).to be_active
        end
      end
    end

    context 'when the bomb is active' do
      context 'when it receives a valid deactivation code' do
        it 'activates the bomb' do
          subject.process_code('1234')
          subject.process_code('0000')


          expect(subject).not_to be_active
        end
      end
    end
  end

  describe '#initialize_session' do
    it 'writes its state to the supplied hash' do
      subject.process_code('1234')
      session = subject.initialize_session

      expect(session[:state]).to eq('activated')
    end
  end

  describe '#update_activation_code' do
    context 'when supplied a valid activation code' do
      it 'updates the activation code' do
        subject.update_activation_code('4567')
        subject.process_code('4567')

        expect(subject).to be_active
      end

      it 'ignores the old validation code' do
        subject.update_activation_code('4567')
        subject.process_code('1234')

        expect(subject).not_to be_active
      end
    end
  end
end
