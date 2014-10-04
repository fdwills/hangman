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

        star_count = 0
        word.each_char do |char|
          star_count = star_count + 1 if char == '*'
        end

        candidate.inject({}) do |r, char|
          unless self.probility_model[char].nil?
            r[char] = star_count * self.probility_model[char]/Float(all)
          end
          r
        end
      end

      def get_data(source)
        model = {}
        f = open(source, 'r')

        f.each do |line|
          word = line.chomp
          # same letter in a word plus 1
          word.split(//).uniq.each do |ch|
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
