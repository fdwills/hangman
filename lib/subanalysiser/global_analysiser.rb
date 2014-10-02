require 'subanalysiser/base'

module HangMan
  module SubAnalysiser
    class GlobalAnalysiser < Base
      def model_file
        "lib/model/all.yaml"
      end

      def predict(word, candidate)
        return nil if self.probility_model.nil?

        all = candidate.inject(0) do |r, char|
          unless self.probility_model[char].nil?
            r = r + self.probility_model[char]
          end
            r
        end

        candidate.inject({}) do |r, char|
          unless self.probility_model[char].nil?
            r[char] = self.probility_model[char]/Float(all)
          end
          r
        end
      end

      def get_data(source)
        model = {}
        f = open(source, 'r')

        f.each do |line|
          word = line.chomp
          word.each_char do |ch|
            if model[ch].nil?
              model[ch] = 1
            else
              model[ch] += 1
            end
          end
        end
        f.close

        model
      end
    end
  end
end
