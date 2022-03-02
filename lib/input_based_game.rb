module WordleInterviewQ
  class InputBasedGame
    def initialize(label: nil)
      @label = label
    end

    def guess(guessed_word)
      print "Guessed #{guessed_word}\n"
      print "What was the clue? (G = green; Y = Yellow; N = grey): "
      clue = $stdin.gets.chomp

      return 'GOT IT' if clue == 'GGGGG'

      clue
    end

    private

    def print(string)
      $stdout.write "[#{@label}]: " if @label
      $stdout.write string
    end
  end
end
