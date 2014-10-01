require 'yaml'

module HangMan
  class Analysiser
    attr_accessor :source, :head_model, :tail_model, :relation_model, :all_model

    HEAD_YAML = "lib/model/head.yaml"
    TAIL_YAML = "lib/model/tail.yaml"
    RELATION_YAML = "lib/model/relation.yaml"
    OVER_ALL_YAML = "lib/model/all.yaml"

    def initialize
      @source = nil
    end

    def analysis(source)
      @source = source
      puts "source file not set!" if @source.nil?

      self.get_head_model
      self.get_tail_model
      open(HEAD_YAML,"w") do |f|
        YAML.dump(@head_model,f)
      end

      open(TAIL_YAML,"w") do |f|
        YAML.dump(@tail_model,f)
      end
    end

    def load
      @head_model = YAML.load_file(HEAD_YAML)
      @tail_model = YAML.load(TAIL_YAML)
      @relation_model = YAML.load(RELATION_YAML)
      @all_model = YAML.load(OVER_ALL_YAML)
    end

    def predict(word, used)
      
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
        if @tail_model[word[0]].nil?
          @tail_model[word[0]] = 1
        else
          @tail_model[word[0]] += 1
        end
      end
      f.close
    end

    def get_tail_model
      @tail_model = {}
      f = open(@source, 'r')
      f.each do |line|
        word = line.chomp
        if @tail_model[word[0]].nil?
          @tail_model[word[0]] = 1
        else
          @tail_model[word[0]] += 1
        end
      end
      f.close
    end
  end
end
