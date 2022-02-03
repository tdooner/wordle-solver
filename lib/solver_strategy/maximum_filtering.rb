module WordleInterviewQ
  module SolverStrategy
    # Reimplemented from:
    # https://notfunatparties.substack.com/p/wordle-solver
    #
    # For each possible guess, evaluate how many words are eliminated if that
    # letter is green/yellow/grey. Pick the word that eliminates the most
    # letters.
    class MaximumFiltering < Base
      OPTIMAL_FIRST_GUESS = 'RAISE'

      def choose_guess
        return OPTIMAL_FIRST_GUESS if first_guess?

        best_guess = { word: nil, non_word: nil }
        best_guess_remaining = { word: Float::INFINITY, non_word: Float::INFINITY }
        worst_best_guess = 0

        Game::WORDS.each do |guess|
          total = each_possible_clue
            .map { |clue| @remaining_words.filter(guess, clue).length }
            .keep_if { |score| score > 0 ? score : nil }

          next if total.empty? # no clues are valid?

          median = total.sort[total.length / 2]

          if median < best_guess_remaining[:word] && @remaining_words.include?(guess)
            best_guess[:word] = guess
            best_guess_remaining[:word] = median
          end
          if median < best_guess_remaining[:non_word]
            best_guess[:non_word] = guess
            best_guess_remaining[:non_word] = median
          end
        end

        if best_guess_remaining[:word] < (best_guess_remaining[:non_word] + 5)
          puts "  (should reduce word set to about #{best_guess_remaining[:word]})"
          best_guess[:word]
        else
          puts "  (should reduce word set to about #{best_guess_remaining[:non_word]})"
          best_guess[:non_word]
        end
      end

    private

      GUESSES = ['N', 'Y', 'G']
      def each_possible_clue
        return to_enum(:each_possible_clue) unless block_given?

        (3 ** 5).times do |i|
          yield (1..5).map { |char| GUESSES[(i / char) % 3] }.join
        end
      end
    end
  end
end
