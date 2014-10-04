require 'json'
require 'yaml'

module HangMan
  module SubAnalysiser
    class Base
      attr_accessor :probility_model
      def initialize
      end

      # build model, save model
      def analysis(source, svm_source: nil)
        data = self.get_data(source)
        open(self.model_file, "w") do |f|
          YAML.dump(data,f)
        end
      end

      # load model
      def load
        @probility_model = YAML.load_file(self.model_file)
      end

      # predict("****", [a,b,c])
      def predict(word, canditate)
        raise
      end

      # generate from source
      def get_data(source)
        raise
      end

      def model_file
        raise
      end
    end
  end
end
