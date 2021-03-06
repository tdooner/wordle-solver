module WordleInterviewQ
  class Solver
    attr_reader :remaining_words, :remaining_guesses, :clues

    ALLOWED_GUESSES = File.read(File.expand_path('../../wordle-allowed-guesses.txt', __FILE__)).lines.map(&:strip).map(&:upcase) | Game::WORDS

    def initialize(game, strategy_class = WordleInterviewQ::SolverStrategy::Random)
      @remaining_words = WordList.new(Game::WORDS.dup)
      @remaining_guesses = WordList.new(ALLOWED_GUESSES.dup)
      @game = game
      @clues = []
      @strategy_class = strategy_class
    end

    def make_guess
      guess = @strategy_class.new(self, @remaining_words, @remaining_guesses).choose_guess
      clue = @game.guess(guess)

      receive_clue(guess, clue)

      [guess, clue]
    end

    def receive_clue(guess, clue)
      return if clue == 'GOT IT'

      clues << clue

      @remaining_words.filter!(guess, clue)
      @remaining_guesses.filter!(guess, clue)
    end

    def print_words_remaining
      puts "               (words remaining: #{solver.remaining_words.length} #{(solver.remaining_words.list.inspect if solver.remaining_words.length < 10)})\n"
    end

    # Returns the guessed word
    def solve
      loop do
        guess = @remaining_guesses.sample
        puts "Remaining words: #{@remaining_words.length} / Remaining guesses: #{@remaining_guesses.length}"

        guess, clue = make_guess
        return guess if clue == 'GOT IT'

        puts "  Guessed #{guess}, Got #{clue}"
      end
    end
  end
end
