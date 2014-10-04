require 'subanalysiser/base'

module HangMan
  module SubAnalysiser
    class RandomAnalysiser < Base
      def analysis(source, svm_source: nil)
      end

      def load
      end

      def predict(word, candidate)
        candidate.inject({}) do |r, char|
          r[char] = 1/Float(candidate.size)
          r
        end
      end
    end
  end
end
