require 'pry'
require 'json'

module WordleInterviewQ
  module SolverStrategy
    # Reimplemented from:
    # https://notfunatparties.substack.com/p/wordle-solver
    #
    # For each possible guess, evaluate how many words are eliminated if that
    # letter is green/yellow/grey. Pick the word that eliminates the most
    # letters.
    class MaximumFilteringQuordle
      PRECOMPUTED_FIRST_GUESS = 'RAISE'

      def initialize(remaining_words_per_game)
        @remaining_words_per_game = remaining_words_per_game
      end

      def choose_guess
        return PRECOMPUTED_FIRST_GUESS if first_guess?

        if (solved = @remaining_words_per_game.find { |list| list.length == 1 })
          return solved.list.first
        end

        best_guess = nil
        best_guess_remaining = Float::INFINITY

        guesses = Solver::ALLOWED_GUESSES.shuffle
        progressbar = nil
        debug { progressbar = ProgressBar.create(total: guesses.length, format: '%t: (%c/%C) |%W| %e') }

        guesses.each do |guess|
          debug { progressbar.increment }

          total = @remaining_words_per_game.sum do |remaining_words|
            possible = each_possible_clue
              .map { |clue| remaining_words.filter(guess, clue).length }
              .max
            puts "possibly one! #{guess}" if possible == 1
            possible
          end

          next if total == 0 # no clues are valid?

          if total < best_guess_remaining
            debug { puts "New best guess: #{guess}, worst case #{total}" }
            best_guess = guess
            best_guess_remaining = total
          elsif total == best_guess_remaining
            debug { puts "Tied guess: #{guess}" }
          end
        end

        best_guess
      rescue Interrupt
        return best_guess
      end

      private

      GUESSES = ['N', 'Y', 'G']
      def each_possible_clue
        return to_enum(:each_possible_clue) unless block_given?

        (3 ** 5).times do |i|
          yield (0..4).map { |char| GUESSES[(i / (3 ** char)) % 3] }.join
        end
      end

      def first_guess?
        @remaining_words_per_game[0].include?(PRECOMPUTED_FIRST_GUESS)
      end

      def debug(&block)
        block.call if ENV['DEBUG']
      end
    end
  end
end
