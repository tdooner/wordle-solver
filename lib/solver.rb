module WordleInterviewQ
  class Solver
    attr_reader :remaining_words, :remaining_guesses

    ALLOWED_GUESSES = File.read(File.expand_path('../../wordle-allowed-guesses.txt', __FILE__)).lines.map(&:strip).map(&:upcase)

    def initialize(game)
      @remaining_words = Game::WORDS.dup
      @remaining_guesses = ALLOWED_GUESSES | @remaining_words
      @game = game
    end

    def make_guess
      guess = @remaining_guesses.sample
      clue = @game.guess(guess)
      
      receive_clue(guess, clue)

      [guess, clue]
    end

    def receive_clue(guess, clue)
      return if clue == 'GOT IT'

      filter_word_list!(@remaining_words, guess, clue)
      filter_word_list!(@remaining_guesses, guess, clue)
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

    private

    def filter_word_list!(list, guess, clue)
      list.filter! { |word| matches_clue?(word, guess, clue) }
    end

    def matches_clue?(word, guess, clue)
      word_letters = word.chars

      # Reject words missing 'G' letters
      clue.chars.each_with_index do |clue_char, i|
        next unless clue_char == 'G'

        return false unless word[i] == guess[i]
        word_letters[i] = nil
      end

      # Reject words with 'N' letters
      clue.chars.each_with_index do |clue_char, i|
        next unless clue_char == 'N'

        return false if word_letters.include?(guess[i])
      end

      # Reject words without remaining 'Y' letters
      clue.chars.each_with_index do |clue_char, i|
        next unless clue_char == 'Y'

        return false unless (clue_index = word_letters.index(guess[i])) && clue_index != i
        word_letters[clue_index] = nil
      end

      true
    end
  end
end
