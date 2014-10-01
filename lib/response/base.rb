require 'json'

module HangMan
  class Response
    attr_accessor :response_body_json

    SUCCESS_STATUS = 200

    def initialize(json)
        @response_body_json = json
    end

    def method_missing(name, *args)
      if name.to_s =~ /^get_(.*)/
        if self.response_body_json[$1].nil?
          super
        else
          self.response_body_json[$1]
        end
      else
        super
      end
    end

    def success?
      self.get_status == SUCCESS_STATUS
    end
  end
end
