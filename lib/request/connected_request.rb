require 'request/base'

module HangMan
  module Request
    class ConnectedRequest < Base
      attr_accessor :secret

      def send
        if self.secret == nil
          puts "secret not set!"
        else
          super
        end
      end
    end
  end
end
