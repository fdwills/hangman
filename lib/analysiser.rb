require 'yaml'

module HangMan
  class Analysiser
    attr_accessor :source, :head_model, :tail_model, :relation_model, :over_all_model, :reverse_relation_model

    HEAD_YAML = "lib/model/head.yaml"
    TAIL_YAML = "lib/model/tail.yaml"
    RELATION_YAML = "lib/model/relation.yaml"
    OVER_ALL_YAML = "lib/model/all.yaml"
    REVERSE_RELATION_YAML = "lib/model/reverse_relation.yaml"

    def initialize
      @source = nil
    end

    def analysis(source)
      @source = source
      puts "source file not set!" if @source.nil?

      self.get_head_model
      self.get_tail_model
      self.get_relation_model
      self.get_reverse_relation_model
      self.get_over_all_model
      open(HEAD_YAML,"w") do |f|
        YAML.dump(@head_model,f)
      end

      open(TAIL_YAML,"w") do |f|
        YAML.dump(@tail_model,f)
      end

      open(RELATION_YAML,"w") do |f|
        YAML.dump(@relation_model,f)
      end

      open(OVER_ALL_YAML,"w") do |f|
        YAML.dump(@over_all_model,f)
      end

      open(REVERSE_RELATION_YAML,"w") do |f|
        YAML.dump(@reverse_relation_model,f)
      end
    end

    def load
      @head_model = YAML.load_file(HEAD_YAML)
      @tail_model = YAML.load_file(TAIL_YAML)
      @relation_model = YAML.load_file(RELATION_YAML)
      @over_all_model = YAML.load_file(OVER_ALL_YAML)
      @reverse_relation_model = YAML.load_file(REVERSE_RELATION_YAML)
    end

    def predict(word, used)
      candidate = ("a".."z").to_a - used
      result = candidate.inject({}) do |r, char|
        r[char] = 0
        r
      end

      for i in (0..word.size - 1) do
        next if word[i] != '*'
        if i == 0
          all = candidate.inject(0) do |r, char|
            if @head_model[char].nil?
              r
            else
              r = r + @head_model[char]
            end
          end
          candidate.each do |char|
            unless @head_model[char].nil?
              result[char] += @head_model[char]/Float(all)
            end
          end
        end

        if i == word.size - 1
          all = candidate.inject(0) do |r, char|
            if @tail_model[char].nil?
              r
            else
              r = r + @tail_model[char]
            end
          end
          candidate.each do |char|
            unless @tail_model[char].nil?
              result[char] += @tail_model[char]/Float(all)
            end
          end
        end

        if i != 0 && word[i-1] != '*'
          all = candidate.inject(0) do |r, char|
            if @relation_model[word[i-1]][char].nil?
              r
            else
              r = r + @relation_model[word[i-1]][char]
            end
          end
          candidate.each do |char|
            unless @relation_model[word[i-1]][char].nil?
              result[char] += @relation_model[word[i-1]][char]/Float(all)
            end
          end
        end

        if (i != word.size - 1) && word[i+1] != '*'
          all = candidate.inject(0) do |r, char|
            if @reverse_relation_model[word[i+1]][char].nil?
              r
            else
              r = r + @reverse_relation_model[word[i+1]][char]
            end
          end
          candidate.each do |char|
            unless @reverse_relation_model[word[i+1]][char].nil?
              result[char] += @reverse_relation_model[word[i+1]][char]/Float(all)
            end
          end
        end

        all = candidate.inject(0) do |r, char|
          if @over_all_model[char].nil?
            r
          else
            r = r + @over_all_model[char]
          end
        end
        candidate.each do |char|
          unless @over_all_model[char].nil?
            result[char] += @over_all_model[char]/Float(all)
          end
        end

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

    def get_head_model
      @head_model = {}
      f = open(@source, 'r')
      f.each do |line|
        word = line.chomp
        if @head_model[word[0]].nil?
          @head_model[word[0]] = 1
        else
          @head_model[word[0]] += 1
        end
      end
      f.close
    end

    def get_tail_model
      @tail_model = {}
      f = open(@source, 'r')
      f.each do |line|
        word = line.chomp
        if @tail_model[word[-1]].nil?
          @tail_model[word[-1]] = 1
        else
          @tail_model[word[-1]] += 1
        end
      end
      f.close
    end

    def get_relation_model
      @relation_model = {}
      f = open(@source, 'r')
      f.each do |line|
        word = line.chomp
        for i in (0..word.size-2) do
          if @relation_model[word[i]].nil?
            @relation_model[word[i]] = {word[i+1] => 1}
          elsif @relation_model[word[i]][word[i+1]].nil?
            @relation_model[word[i]][word[i+1]] = 1
          else
            @relation_model[word[i]][word[i+1]] += 1
          end
        end
      end
      f.close
    end

    def get_reverse_relation_model
      @reverse_relation_model = {}
      f = open(@source, 'r')
      f.each do |line|
        word = line.chomp
        for i in (1..word.size-1) do
          if @reverse_relation_model[word[i]].nil?
            @reverse_relation_model[word[i]] = {word[i-1] => 1}
          elsif @reverse_relation_model[word[i]][word[i-1]].nil?
            @reverse_relation_model[word[i]][word[i-1]] = 1
          else
            @reverse_relation_model[word[i]][word[i-1]] += 1
          end
        end
      end
      f.close
    end

    def get_over_all_model
      @over_all_model = {}
      f = open(@source, 'r')
      f.each do |line|
        word = line.chomp
        word.each_char do |ch|
          if @over_all_model[ch].nil?
            @over_all_model[ch] = 1
          else
            @over_all_model[ch] += 1
          end
        end
      end
      f.close
    end
  end
end
