require File.expand_path(File.join(File.dirname(__FILE__), '..', 'spec_helper'))

describe Cleverbot::Client do
  subject { Cleverbot::Client }

  it 'should include HTTParty' do |variable|
    should <= HTTParty
  end

  describe '::DEFAULT_PARAMS' do
    subject { Cleverbot::Client::DEFAULT_PARAMS }

    it do
      should eq({
        'stimulus' => '',
        'vText2' => '',
        'vText3' => '',
        'vText4' => '',
        'vText5' => '',
        'vText6' => '',
        'vText7' => '',
        'vText8' => '',
        'sessionid' => '',
        'cb_settings_language' => 'en',
        'cb_settings_scripting' => 'no',
        'islearning' => '1',
        'icognoid' => 'wsf',
        'icognocheck' => '',
      })
    end
  end

  describe '::PATH' do
    subject { Cleverbot::Client::PATH }

    it { should == '/webservicemin' }
  end

  describe '.base_uri' do
    subject { Cleverbot::Client.base_uri }

    it { should == 'http://www.cleverbot.com' }
  end

  describe '.parser' do
    subject { Cleverbot::Client.parser }

    it { should == Cleverbot::Parser }
  end

  describe '.write' do
    subject { Cleverbot::Client.write @message, @params }

    context 'with an empty message' do
      before(:each) do
        @message = ''
        @params = {}
      end

      it 'should respond with params' do
        expect(subject).to be_a(Hashie::Mash)
        expect(subject).to respond_to(:sessionid)
      end
    end
  end

  describe '#initialize' do
    subject { Cleverbot::Client.new @params }

    context 'with params { "a" => "b" }' do
      before :each do
        @params = { 'a' => 'b' }
      end

      it 'sets #params to { "a" => "b" }' do
        subject.params.should == { 'a' => 'b' }
      end
    end
  end

  describe '#write' do
    before :each do
      @client = Cleverbot::Client.new
    end

    subject { @client.write @message }

    context 'with an empty message' do
      before :each do
        @message = ''
      end

      it 'should add stimulus => "" to the post body' do
        @client.should_receive(:send_message_request) do |body|
          expect(body).to include('stimulus' => '')
          {}
        end
        
        subject
      end

      context 'when digest returns abcd' do
        let(:hex_digest) { "e2fc714c4727ee9395f324cd2e7f331f" }

        before :each do
          Digest::MD5.stub(:hexdigest).and_return hex_digest
        end

        it 'should add icognocheck to the post body' do
          @client.should_receive(:send_message_request) do |body|
            expect(body).to include('icognocheck' => hex_digest)
            {}
          end

          subject
        end
      end
    end

    context 'with a message containing "Hi!"' do
      let(:user_message) { "Hi!" }

      before :each do
        @message = user_message
      end

      it 'should add stimulus => "Hi!" to the post body' do
        @client.should_receive(:send_message_request) do |body|
          expect(body).to include('stimulus' => user_message)
          {}
        end

        subject
      end
    end
  end
end
