require 'subanalysiser/base'

module HangMan
  module SubAnalysiser
    class ReverseRelationAnalysiser < Base
      def model_file
        "lib/model/reverse_relation.yaml"
      end

      def predict(word, candidate)
        return nil if self.probility_model.nil?

        result = {}
        for i in (0..word.size - 2) do
          next if word[i+1] == '*'

          all = candidate.inject(0) do |r, char|
            unless self.probility_model[word[i+1]][char].nil?
              r = r + self.probility_model[word[i+1]][char]
            end
            r
          end

          candidate.inject(result) do |r, char|
            unless self.probility_model[word[i+1]][char].nil?
              r[char] = self.probility_model[word[i+1]][char]/Float(all)
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
          for i in (1..word.size-1) do
            if relation_model[word[i]].nil?
              relation_model[word[i]] = {word[i-1] => 1}
            elsif relation_model[word[i]][word[i-1]].nil?
              relation_model[word[i]][word[i-1]] = 1
            else
              relation_model[word[i]][word[i-1]] += 1
            end
          end
        end
        f.close

        relation_model
      end
    end
  end
end
