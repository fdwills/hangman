$LOAD_PATH << File.join(File.dirname(__FILE__), 'lib')
require 'hangman'

HIGHT_SCORE_FILE = "log/high_score"
RESULT_FILE = "log/result.txt"
SUBMIT_FILE = "log/submit.txt"

while true
  begin
    f = open(HIGHT_SCORE_FILE, 'r')
    high_score = f.gets.chomp.to_i
    f.close

    game = HangMan::Game.new
    game.add_analysiser(HangMan::SubAnalysiser::HeadAnalysiser.new, 1)
    game.add_analysiser(HangMan::SubAnalysiser::TailAnalysiser.new, 1)
    game.add_analysiser(HangMan::SubAnalysiser::RelationAnalysiser.new, 1)
    game.add_analysiser(HangMan::SubAnalysiser::ReverseRelationAnalysiser.new, 1)
    game.add_analysiser(HangMan::SubAnalysiser::GlobalAnalysiser.new, 1)
    #game.add_analysiser(HangMan::SubAnalysiser::SvmAnalysiser.new, 1)
    #game.add_analysiser(HangMan::SubAnalysiser::RandomAnalysiser.new, 1)
    game.play(analysis: true)
    #game.play

    score = 0
    game.get_result do |json|
      f = open(RESULT_FILE, 'a')
      f.write(json.to_s)
      f.write("\n")
      f.close
      score = json["data"]["totalScore"].to_i
    end

    if score > high_score
      puts "Submit result!"

      game.submit do |json|
        f = open(SUBMIT_FILE, 'a')
        f.write(json.to_s)
        f.write("\n")
        f.close
      end

      f = open(HIGH_SCORE_FILE, 'w')
      f.write(score)
      f.close
    else
      puts "Ignore result!"
    end
  end
end
