require 'yaml'
require 'subanalysiser/head_analysiser'
require 'subanalysiser/reverse_relation_analysiser'
require 'subanalysiser/global_analysiser'
require 'subanalysiser/relation_analysiser'
require 'subanalysiser/tail_analysiser'

module HangMan
  class NewAnalysiser
    attr_accessor :source, :models

    def initialize
      @source = nil
      @models = []
      @models << SubAnalysiser::HeadAnalysiser.new
      @models << SubAnalysiser::TailAnalysiser.new
      @models << SubAnalysiser::GlobalAnalysiser.new
      @models << SubAnalysiser::RelationAnalysiser.new
      @models << SubAnalysiser::ReverseRelationAnalysiser.new
    end

    def analysis(source)
      @models.each do |model|
        model.analysis(source)
      end
    end

    def load
      @models.each do |model|
        model.load
      end
    end

    def predict(word, used)
      candidate = ("a".."z").to_a - used
      result = candidate.inject({}) do |r, char|
        r[char] = 0
        r
      end

      @models.inject(result) do |r, model|
        probilitys = model.predict(word, candidate)

        candidate.each do |char|
          unless probilitys[char].nil?
            result[char] += probilitys[char]
          end
        end

        result
      end

      output = 'a'
      probility = 0
      result.each_pair do |char, pro|
        if pro > probility
          output = char
          probility = pro
        end
      end

      output
    end
  end
end
