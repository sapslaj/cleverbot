require File.expand_path(File.join(File.dirname(__FILE__), 'spec_helper'))

describe Cleverbot do
  describe "high level integration" do
    context "with a client instance" do
      let(:client) { Cleverbot::Client.new }

      it 'should give a proper response' do
        expect(client.write "hi.").to match(/\A[A-Z].+\z/)
      end
    end
  end
end
