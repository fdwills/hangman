require 'request/connected_request'

module HangMan
  module Request
    class SubmitRequest < ConnectedRequest
      def initialize(user_id)
        super("submitTestResults", user_id)
      end
    end
  end
end
