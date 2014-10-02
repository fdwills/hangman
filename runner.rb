$LOAD_PATH << File.join(File.dirname(__FILE__), 'lib')
require 'game'

module HangMan
  while true
    begin
      game = Game.new
      game.play

      f = open("result.txt", 'a')
      f.write(game.get_result.to_s)
      f.write("\n")
      f.close
    rescue => e
      puts "Error !!"
      sleep(60)
    end
  end
end
