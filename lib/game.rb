require 'analysiser'
require 'forwardable'
require 'network'

module HangMan
  class Game
    extend Forwardable
    USER_ID = 'weirenzhong@gmail.com'
    SOURCE_FILE = 'raw_data/100k_samples.pure'
    LOG_FILE = 'log/log.txt'
    SVM_SOURCE_FILE = 'raw_data/svm_data.data'

    attr_accessor :ana, :secret, :number_of_words

    def_delegators :@ana, :add_analysiser

    # initiale will send a init game request, and get the key
    def initialize
      request = Request::InitiateRequest.new(USER_ID)
      login_res = Response.new(request.send)
      if login_res.success?
        @secret = login_res.get_secret
        @number_of_words = login_res.get_data['numberOfWordsToGuess']
      end

      @ana = Analysiser.new
    end

    # run numberOfWordsToGuess time
    # guess using the conbination a all the added models
    def play(analysis: false)
      raise if @ana.models.size == 0

      # update predict model
      # can be skiped, svm traing costs too much time
      @ana.analysis(SOURCE_FILE, svm_source: SVM_SOURCE_FILE) if analysis

      # load predict file in lib/model/*
      @ana.load

      @number_of_words.times do
        # get a word
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
              # update log
              # used for svm training
              self.log(pattern, guessed.to_s, next_pattern)

              if guess_response.get_word.include?('*')
                if guess_response.get_data['numberOfGuessAllowedForThisWord'] == 0
                  break
                end
              else
                # update words
                # used for letter frequency
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
      yield request.send
    end

    def submit
      request = Request::SubmitRequest.new(USER_ID)
      request.secret = @secret
      yield request.send
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
