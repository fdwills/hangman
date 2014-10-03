require 'analysiser'
require 'new_analysiser'
require 'network'

module HangMan
  class Game
    USER_ID = 'weirenzhong@gmail.com'
    SOURCE_FILE = 'raw_data/100k_samples.pure'
    LOG_FILE = 'log.txt'

    attr_accessor :ana, :secret, :number_of_words
    def initialize
      request = Request::InitiateRequest.new(USER_ID)
      login_res = Response.new(request.send)
      if login_res.success?
        @secret = login_res.get_secret
        @number_of_words = login_res.get_data['numberOfWordsToGuess']
      end

      @ana = NewAnalysiser.new
    end

    def add_analysiser(analysiser)
      @ana.add_analysiser(analysiser)
      self
    end

    def play
      raise if @ana.models.size == 0

      # update predict model
      @ana.analysis(SOURCE_FILE)

      # load predict file in lib/model/*
      @ana.load

      @number_of_words.times do
        request = Request::NextwordRequest.new(USER_ID)
        request.secret = @secret
        word_res = Response.new(request.send)

        # init
        pattern = word_res.get_word.downcase
        guessed = []

        if word_res.success?
          while true
            pchar = @ana.predict(pattern, guessed)
            guessed << pchar
            guess_request = Request::GuessRequest.new(USER_ID, pchar)
            guess_request.secret = secret
            guess_response = Response.new(guess_request.send)

            if guess_response.success?
              next_pattern = guess_response.get_word.downcase
              self.log(pattern, guessed.to_s, next_pattern)

              if guess_response.get_word.include?('*')
                if guess_response.get_data['numberOfGuessAllowedForThisWord'] == 0
                  break
                end
              else
                self.append_source(guess_response.get_word.downcase)
                break
              end

              pattern = next_pattern
            end
          end
        end
        sleep(1)
      end
    end

    def get_result
      request = Request::ResultRequest.new(USER_ID)
      request.secret = @secret
      request.send
    end

    def submit
      request = Request::SubmitRequest.new(USER_ID)
      request.secret = @secret
      request.send
    end

    def append_source(word)
      f = open(SOURCE_FILE, "a")
      f.write(word)
      f.write("\n")
      f.close
    end

    def log(origin, guess, result)
      f = open(LOG_FILE, "a")
      f.write(origin + "\t" + guess + "\t" + result)
      f.write("\n")
      f.close
    end
  end
end
