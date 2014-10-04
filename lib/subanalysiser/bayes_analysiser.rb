require 'subanalysiser/base'
require 'yaml'

module HangMan
  module SubAnalysiser
    class BayesAnalysiser < Base

      GLOBAL_MODEL = "lib/model/all.yaml"

      def model_file
        "lib/model/bayes.yaml"
      end

      def predict(word, candidate)
        return nil if self.probility_model.nil?
        globle_model = YAML.load_file(GLOBAL_MODEL)
        global_all = globle_model.values.inject do |r, v|
          r = r + v
        end

        result = {}
        word.split(//).uniq.each do |char1|
          next if char1 == '*'

          all = candidate.inject(0) do |r, char2|
            unless self.probility_model[char1][char2].nil?
              r = r + self.probility_model[char1][char2]
            end
            r
          end

          candidate.inject(result) do |r, char2|
            unless self.probility_model[char1][char2].nil?
              if r[char2].nil?
                r[char2] = self.probility_model[char1][char2]/Float(all) * globle_model[char1] / global_all
              else
                r[char2] = r[char2] + self.probility_model[char1][char2]/Float(all) * globle_model[char1] / global_all
              end
            end
            r
          end
        end

        result
      end

      def get_data(source)
        relation_model = {}
        f = open(source, 'r')
        f.each do |line|
          word = line.chomp
          word.split(//).uniq.each do |char|
            ('a'..'z').to_a.each do |char2|
              next if char == char2

              # martix
              if relation_model[char].nil?
                relation_model[char] = {char2 => 1}
              elsif relation_model[char][char2].nil?
                relation_model[char][char2] = 1
              else
                relation_model[char][char2] += 1
              end

              if relation_model[char2].nil?
                relation_model[char2] = {char => 1}
              elsif relation_model[char2][char].nil?
                relation_model[char2][char] = 1
              else
                relation_model[char2][char] += 1
              end
            end
          end
        end
        f.close

        relation_model
      end
    end
  end
end
