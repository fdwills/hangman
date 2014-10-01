require 'request/connected_request'

module HangMan
  module Request
    class GuessRequest < ConnectedRequest
      attr_accessor :guess

      def initialize(user_id, guess)
        @guess = guess.upcase
        super("guessWord", user_id)
      end
    end
  end
end
