require 'request/connected_request'

module HangMan
  module Request
    class NextwordRequest < ConnectedRequest
      def initialize(user_id)
        super("nextWord", user_id)
      end
    end
  end
end
