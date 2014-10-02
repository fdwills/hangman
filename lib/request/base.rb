require 'json'
require 'net/https'
require 'uri'

module HangMan
  module Request
    class Base
      attr_accessor :action, :userId

      TARGET_URL = 'http://strikingly-interview-test.herokuapp.com/guess/process '
      def initialize(action, userId)
        @action, @userId = action, userId
      end

      def request_body_json
        request = self.instance_variables.inject({}) do |result, name|
          if name.to_s =~ /^@(.*)/
            result[$1] = self.instance_variable_get(name)
          end

          result
        end

        request.to_json
      end

      def send
        uri = URI(TARGET_URL)
        http = Net::HTTP.new(uri.host, uri.port)
        request = Net::HTTP::Post.new(uri.request_uri)
        request['Accept'] = "application/json"
        request['Content-Type'] = "application/json"
        request.body = self.request_body_json
        puts "Sending request: " + self.request_body_json

        response = http.request(request)

        puts "Got: " + response.body, "\n"
        JSON.parse(response.body)
      end
    end
  end
end
