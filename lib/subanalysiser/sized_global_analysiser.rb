require 'subanalysiser/base'

module HangMan
  module SubAnalysiser
    class SizedGlobalAnalysiser < Base
      def model_file
        "lib/model/sized_all.yaml"
      end

      def predict(word, candidate)
        return nil if self.probility_model.nil?

        key = to_key(word)
        my_model = self.probility_model[:all]
        unless self.probility_model[key].nil?
          my_model = self.probility_model[key]
        end

        all = candidate.inject(0) do |r, char|
          unless my_model[char].nil?
            r = r + my_model[char]
          end
          r
        end

        star_count = 0
        word.each_char do |char|
          star_count = star_count + 1 if char == '*'
        end

        candidate.inject({}) do |r, char|
          if my_model[char].nil?
            r[char] = 0
          else
            r[char] = star_count * my_model[char]/Float(all)
          end
          r
        end
      end

      def get_data(source)
        model = {all: {}}
        f = open(source, 'r')

        f.each do |line|
          word = line.chomp
          key = to_key(word)

          if model[key].nil?
            model[key] = {}
          end
          # same letter in a word plus 1
          word.split(//).uniq.each do |ch|
            if model[:all][ch].nil?
              model[:all][ch] = 1
            else
              model[:all][ch] += 1
            end

            if model[key][ch].nil?
              model[key][ch] = 1
            else
              model[key][ch] += 1
            end
          end
        end
        f.close

        model
      end

      def to_key(word)
        "l#{word.size}".to_sym
      end
    end
  end
end
