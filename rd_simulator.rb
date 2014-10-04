$LOAD_PATH << File.join(File.dirname(__FILE__), 'lib')
require 'hangman'

SOURCE_FILE = 'raw_data/100k_samples.pure'
OUT_FILE = 'raw_data/svm_data.data'

def guess(origin, now, guessed_letter)
  result = now.split(//)
  origin.split(//).each_with_index do |ch, i|
    if ch == guessed_letter
      result[i] = ch
    end
  end
  result.join
end

words = []
f = open(SOURCE_FILE, 'r')
f.each do |line|
  words << line.chomp
end
f.close

all = ('a'..'z').to_a
f = open(OUT_FILE, "w")
10000.times do
  # select a word
  word = words.sample
  origin = '*' * word.size
  guessed = []
  time = 10

  while true
    # guess a letter
    candidate = all - guessed
    letter_guess = candidate.sample
    guessed << letter_guess

    result = guess(word, origin, letter_guess)

    f.write(origin + "\t" + guessed.to_s + "\t" + result)
    f.write("\n")

    if origin == result
      time = time -1
    end

    break if time == 0
    break unless result.include?('*')
    origin = result
  end
end
f.close

HangMan::SubAnalysiser::SvmAnalysiser.new.analysis(nil, svm_source: OUT_FILE)
