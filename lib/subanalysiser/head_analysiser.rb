require 'subanalysiser/base'

module HangMan
  module SubAnalysiser
    class HeadAnalysiser < Base
      def model_file
        "lib/model/head.yaml"
      end

      def predict(word, candidate)
        return nil if self.probility_model.nil?
        return nil if word[0] != '*'

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
        head_model = {}
        f = open(source, 'r')
        f.each do |line|
          word = line.chomp
          if head_model[word[0]].nil?
            head_model[word[0]] = 1
          else
            head_model[word[0]] += 1
          end
        end
        f.close

        head_model
      end
    end
  end
end
