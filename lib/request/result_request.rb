require 'request/connected_request'

module HangMan
  module Request
    class ResultRequest < ConnectedRequest
      def initialize(user_id)
        super("getTestResults", user_id)
      end
    end
  end
end
