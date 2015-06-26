require File.expand_path(File.join(File.dirname(__FILE__), 'spec_helper'))

describe Cleverbot, :no_vcr do
  describe "high level integration" do
    subject { Cleverbot::Client }
    let(:response) { subject.write('hi.') }
    let(:valid_message) { /\A[A-Z].+\z/ }

    context "with a client instance" do
      subject { Cleverbot::Client.new }

      it 'should give a proper string response' do
        expect(response).to be_a(String)
        expect(response).to match(valid_message)
      end
    end

    context "using singleton" do
      it 'should respond with params' do
        expect(response).to be_a(Hashie::Mash)
        expect(response).to respond_to(:sessionid)
      end

      it 'should have a message' do
        expect(response).to have_key(:message)
        expect(response[:message]).to match(valid_message)
      end
    end
  end
end
