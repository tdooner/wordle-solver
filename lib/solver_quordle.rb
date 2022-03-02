module WordleInterviewQ
  class SolverQuordle
    ALLOWED_GUESSES = File.read(File.expand_path('../../wordle-allowed-guesses.txt', __FILE__)).lines.map(&:strip).map(&:upcase) | Game::WORDS

    def initialize(game1, game2, game3, game4)
      @games = Array.new(4) { { solved: false, remaining_words: WordList.new(Game::WORDS.dup) } }
      @games[0][:game_instance] = game1
      @games[1][:game_instance] = game2
      @games[2][:game_instance] = game3
      @games[3][:game_instance] = game4
    end

    def make_guess
      solver_strategy = SolverStrategy::MaximumFilteringQuordle.new(
        @games
          .filter { |game_item| !game_item[:solved] }
          .map { |game_item| game_item[:remaining_words] }
      )
      guess = solver_strategy.choose_guess

      @games.each do |game_item|
        next if game_item[:solved]
        clue = game_item[:game_instance].guess(guess)

        receive_clue(game_item, guess, clue)
      end

      return [nil, 'GOT IT'] if @games.all? { |game_item| game_item[:solved] }
    end

    def receive_clue(game_item, guess, clue)
      if clue == 'GOT IT'
        game_item[:solved] = true
      end

      game_item[:remaining_words].filter!(guess, clue)
    end

    def print_words_remaining
      @games.each do |game_item|
        puts "               (words remaining: #{game_item[:remaining_words].length} #{(game_item[:remaining_words].list.inspect if game_item[:remaining_words].length < 10)})\n"
      end
    end

    # Returns the guessed word
    def solve
      loop do
        puts "Remaining words: #{@games.map { |game_item| game_item[:remaining_words].length }}"

        guess, clue = make_guess
        return guess if clue == 'GOT IT'

        puts "  Guessed #{guess}, Got #{clue}"
      end
    end
  end
end
