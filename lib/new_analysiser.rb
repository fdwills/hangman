require 'yaml'

module HangMan
  class NewAnalysiser
    attr_accessor :source, :models

    def initialize
      @source = nil
      @models = []
    end

    def add_analysiser(analysiser, weight)
      @models << [analysiser, weight]
    end

    def analysis(source)
      @models.each do |model, weight|
        model.analysis(source)
      end
    end

    def load
      @models.each do |model, weight|
        model.load
      end
    end

    def predict(word, used)
      candidate = ("a".."z").to_a - used
      result = candidate.inject({}) do |r, char|
        r[char] = 0
        r
      end

      @models.inject(result) do |r, model_pair|
        model, weight = model_info
        probilitys = model.predict(word, candidate)

        candidate.each do |char|
          unless probilitys[char].nil?
            result[char] += weight * probilitys[char]
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
