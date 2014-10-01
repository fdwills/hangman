require 'request/base'

module HangMan
  module Request
    class InitiateRequest < Base
      def initialize(user_id)
        super("initiateGame", user_id)
      end
    end
  end
end
