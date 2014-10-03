$LOAD_PATH << File.join(File.dirname(__FILE__), 'lib')
require 'game'
require 'subanalysiser/head_analysiser'
require 'subanalysiser/reverse_relation_analysiser'
require 'subanalysiser/global_analysiser'
require 'subanalysiser/relation_analysiser'
require 'subanalysiser/tail_analysiser'

while true
  begin
    game = HangMan::Game.new
    game.add_analysiser(HangMan::SubAnalysiser::HeadAnalysiser.new)
    game.add_analysiser(HangMan::SubAnalysiser::TailAnalysiser.new)
    game.add_analysiser(HangMan::SubAnalysiser::RelationAnalysiser.new)
    game.add_analysiser(HangMan::SubAnalysiser::ReverseRelationAnalysiser.new)
    game.add_analysiser(HangMan::SubAnalysiser::GlobalAnalysiser.new)
    game.play

    f = open("result.txt", 'a')
    f.write(game.get_result.to_s)
    f.write("\n")
    f.close

    if game.get_result["data"]["totalScore"] > 1000
      game.submit
    end
  rescue => e
    puts "Error !!"
    sleep(60)
  end
end
