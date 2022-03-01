module WordleInterviewQ
  class InputBasedGame
    WORDS = File.read(File.expand_path('../../words.txt', __FILE__)).lines.map(&:strip).map(&:upcase)

    def initialize
    end

    def guess(guessed_word)
      puts "Guessed #{guessed_word}"
      $stdout.write "What was the clue? (G = green; Y = Yellow; N = grey): "
      clue = $stdin.gets.chomp

      return 'GOT IT' if clue == 'GGGGG'

      clue
    end
  end
end
