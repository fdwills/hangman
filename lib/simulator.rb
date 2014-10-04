module HangMan
  class Simulator
    attr_accessor :word, :current, :current_life

    SOURCE_FILE = 'raw_data/100k_samples.pure'
    LIFE = 10
    @@word_list = []

    def initialize
      if @@word_list.size == 0
        f = open(SOURCE_FILE, 'r')
        f.each do |line|
          @@word_list << line.chomp
        end
        f.close
      end

      @word = @@word_list.sample
      @current = '*' * @word.size
      @current_life = LIFE
    end

    def guess(guessed_letter)
      matched = false
      @word.split(//).each_with_index do |ch, i|
        if ch == guessed_letter
          @current[i] = ch
          matched = true
        end
      end
      @current_life = @current_life - 1 if !matched
      [@current, @current_life]
    end
  end
end
