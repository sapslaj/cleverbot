require 'cleverbot/parser'

module Cleverbot
  # Ruby wrapper for Cleverbot.com.
  class Client
    include HTTParty

    # The default form variables for POSTing to Cleverbot.com
    DEFAULT_PARAMS = {
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
    }

    # The path to the form endpoint on Cleverbot.com.
    PATH = '/webservicemin'

    base_uri 'http://www.cleverbot.com'

    parser Parser
    headers ({
      'Accept-Encoding' => 'gzip',
      'User-Agent' => 'Mozilla/5.0 (X11; Linux x86_64; rv:29.0) Gecko/20100101 Firefox/29.0',
      'Accept' => 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8',
      'Accept-Language' => 'fr-fr,fr;q=0.8,en-us;q=0.5,en;q=0.3',
      'X-Moz' => 'prefetch',
      'Accept-Charset' => 'ISO-8859-1,utf-8;q=0.7,*;q=0.7',
      'Content-Type' => 'application/x-www-form-urlencoded; charset=UTF-8',
      'Referer' => 'http://www.cleverbot.com',
      'Cache-Control' => 'no-cache, no-cache',
      'Pragma' => 'no-cache'
    })

    # Holds the parameters for an instantiated Client.
    attr_reader :params

    # Holds the session cookies
    attr_reader :cookies


    # Sends a message to Cleverbot.com and returns a <tt>Hash</tt> containing the parameters received.
    #
    # ==== Parameters
    #
    # [<tt>message</tt>] Optional <tt>String</tt> holding the message to be sent. Defaults to <tt>''</tt>.
    # [<tt>params</tt>] Optional <tt>Hash</tt> with form parameters. Merged with DEFAULT_PARAMS. Defaults to <tt>{}</tt>.
    def self.write message='', params={}
      client = self.new(params)
      {:message => client.write(message)}.merge! client.params
    end

    # Initializes a Client with given parameters.
    #
    # ==== Parameters
    #
    # [<tt>params</tt>] Optional <tt>Hash</tt> holding the initial parameters. Defaults to <tt>{}</tt>.
    def initialize params={}
      @params = params
      @cookies = {}

      set_cookies
    end

    # Sends a message and returns a <tt>String</tt> with the message received. Updates #params to maintain state.
    #
    # ==== Parameters
    #
    # [<tt>message</tt>] Optional <tt>String</tt> holding the message to be sent. Defaults to <tt>''</tt>.
    def write message=''
      cookie_string = @cookies.map{|(k, v)| "#{k}=#{v}"}.join(";")

      body = DEFAULT_PARAMS.merge @params
      body['stimulus'] = message
      body['icognocheck'] = digest(HashConversions.to_params(body))

      response = self.class.post(PATH, :body => body, headers: {'Cookie' => cookie_string})

      set_cookies(response)

      parsed_response = response.parsed_response

      message = parsed_response['message']
      parsed_response.keep_if { |key, value| DEFAULT_PARAMS.keys.include? key }
      @params.merge! parsed_response
      @params.delete_if { |key, value| DEFAULT_PARAMS[key] == value }
      message
    end

    private

    # Gets cookies needed to interact with new Jabberwacky server.
    def set_cookies(response=nil)
      response ||= self.class.get("/")
      response.headers['set-cookie'].split(";").each do |cookie|
        k, v = cookie.split("=")
        @cookies[k] = v
      end
    end

    # Creates a digest from the form parameters.
    #
    # ==== Parameters
    #
    # [<tt>body</tt>] <tt>String</tt> to be digested.
    def digest body
      Digest::MD5.hexdigest body[9...35]
    end

    # Changes keys in hash to symbols
    def symbolize_keys hash
      transform_keys(hash) { |k| k.to_sym }
    end

    # Changes keys in hash to strings
    def stringify_keys hash
      transform_keys(hash) { |k| k.to_s }
    end

    # General purpose hash key transformation factory
    def transform_keys hash
      transformed_hash = {}
      hash.each_pair do |key, value|
        transformed_hash[yield(key)] = value
      end
      transformed_hash
    end
  end
end
