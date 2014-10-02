module HangMan
  module SubAnalysiser
    class Base
      attr_accessor :probility_model
      def initialize
      end

      def analysis(source)
        data = self.get_data(source)
        open(self.model_file, "w") do |f|
          YAML.dump(data,f)
        end
      end

      def load
        @probility_model = YAML.load_file(self.model_file)
      end

      def predict(word, used)
        raise
      end


      def get_data(source)
        raise
      end

      def model_file
        raise
      end

    end
  end
end
