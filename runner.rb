$LOAD_PATH << File.join(File.dirname(__FILE__), 'lib')
require 'network'
require 'analysiser'

module HangMan

=begin
  USER_ID = 'weirenzhong@gmail.com'

  request = Request::InitiateRequest.new(USER_ID)
  login_res = Response.new(request.send)

  if login_res.success?
    login_res.get_data['numberOfWordsToGuess'].times do
      request = Request::NextWordRequest.new(USER_ID)
      request.secret = login_res.get_secret

      word_res = Response.new(request.send)
      if word_res.success?
      end
      sleep(500)
    end
  end
=end

  ana = Analysiser.new
  ana.analysis('raw_data/100k_samples.pure')
  ana.load
end
