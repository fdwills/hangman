$LOAD_PATH << File.join(File.dirname(__FILE__), 'lib')
require 'hangman'
require 'simulator'
require 'analysiser'

ALL = ('a'..'z').to_a
OUT_FILE = 'log/simulator_log.txt'

ana = HangMan::Analysiser.new
#ana.add_analysiser(HangMan::SubAnalysiser::BayesAnalysiser.new, 1)
ana.add_analysiser(HangMan::SubAnalysiser::GlobalAnalysiser.new, 1)
#ana.add_analysiser(HangMan::SubAnalysiser::SizedGlobalAnalysiser.new, 1)
ana.add_analysiser(HangMan::SubAnalysiser::HeadAnalysiser.new, 1)
ana.add_analysiser(HangMan::SubAnalysiser::TailAnalysiser.new, 1)
ana.add_analysiser(HangMan::SubAnalysiser::RelationAnalysiser.new, 1)
ana.add_analysiser(HangMan::SubAnalysiser::ReverseRelationAnalysiser.new, 1)
#ana.add_analysiser(HangMan::SubAnalysiser::SvmAnalysiser.new, 1)
ana.load

total = 0
100.times do
success = 0
wrong_guess = 0

80.times do
  # select a word
  simutator = HangMan::Simulator.new
  origin = simutator.current.clone
  guessed = []

  while true
    # guess a letter
    letter_guess = ana.predict(origin, guessed)
    guessed << letter_guess

    result, life = simutator.guess(letter_guess)
    #puts origin + " " + result + " " + life.to_s

    # wrong ++
    wrong_guess = wrong_guess + 1 if result == origin

    # success ++ && die
    unless result.include?('*')
      success = success + 1
      break
    end

    # die
    break if life == 0

    origin = result.clone
  end
end

f = open(OUT_FILE, "a")
  f.write(20 * success - wrong_guess)
  f.write("\n")
f.close
total = total + 20 * success - wrong_guess
end

puts total/100
