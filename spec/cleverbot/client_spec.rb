require File.expand_path(File.join(File.dirname(__FILE__), '..', 'spec_helper'))

describe Cleverbot::Client do
  it 'should include HTTParty' do
    should <= HTTParty
  end

  describe Cleverbot::Client::DEFAULT_PARAMS do
    it do
      should equal({
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

  describe Cleverbot::Client::PATH do
    it { should == '/webservicemin' }
  end

  describe Cleverbot::Client.base_uri do
    it { should == 'http://www.cleverbot.com' }
  end

  describe Cleverbot::Client.parser do
    it { should == Cleverbot::Parser }
  end

  describe '.write' do
    subject { Cleverbot::Client.write @message, @params }

    context 'with params {}' do
      before :each do
        @params = {}
      end

      context 'with an empty message' do
        before :each do
          @message = ''
        end

        it 'should post to PATH' do
          Cleverbot::Client.should_receive(:post)
          subject
        end

        it 'should add stimulus => "" to the post body' do
          Cleverbot::Client.should_receive(:post).with(Cleverbot::Client::PATH, :body => hash_including('stimulus' => ''))
          subject
        end

        context 'when digest returns abcd' do
          let(:hex_digest) { "e2fc714c4727ee9395f324cd2e7f331f" }
          before :each do
            Digest::MD5.stub(:hexdigest).and_return hex_digest
          end

          it 'should add icognocheck => "abcd" to the post body' do
            Cleverbot::Client.should_receive(:post).with(Cleverbot::Client::PATH, :body => hash_including('icognocheck' => hex_digest))
            subject
          end
        end

        context 'when the parsed response is {}' do
          before :each do
            Cleverbot::Client.stub(:post).and_return double(:parsed_response => {})
          end

          it { should == {} }
        end
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

      it 'should post to PATH' do
        Cleverbot::Client.should_receive(:post)
        subject
      end

      it 'should add stimulus => "" to the post body' do
        Cleverbot::Client.should_receive(:post).with(Cleverbot::Client::PATH, :body => hash_including('stimulus' => ''))
        subject
      end

      context 'when digest returns abcd' do
        let(:hex_digest) { "e2fc714c4727ee9395f324cd2e7f331f" }

        before :each do
          Digest::MD5.stub(:hexdigest).and_return hex_digest
        end

        it 'should add icognocheck to the post body' do
          Cleverbot::Client.should_receive(:post).with(Cleverbot::Client::PATH, :body => hash_including('icognocheck' => hex_digest))
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
        Cleverbot::Client.should_receive(:post).with(Cleverbot::Client::PATH, :body => hash_including('stimulus' => user_message))
        subject
      end
    end
  end
end
