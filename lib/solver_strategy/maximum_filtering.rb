require 'pry'
require 'progressbar'
require 'json'

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

      # TODO: Refactor this into something that doesn't copy code
      def self.precompute
        output = {}

        puts "Calculating optimal guess for first guess..."
        instance = new(nil, WordList.new(Game::WORDS), Solver::ALLOWED_GUESSES)
        output[:first] = instance.choose_guess(disable_optimizations: true)

        instance.send(:each_possible_clue) do |clue|
          puts "Calculating optimal follow-up guess for #{clue}"
          remaining_words = WordList.new(Game::WORDS.dup).filter(output[:first], clue)
          instance = new(nil, remaining_words, Solver::ALLOWED_GUESSES)
          output[clue] = instance.choose_guess(disable_optimizations: true)
          puts "It's #{output[clue]}"
        end

        File.open('./.precomputed-maximum-filtering.json', 'w') { |f| f.write(JSON.dump(output)) }
      end

      def precomputed_results
      end

      def choose_guess(disable_optimizations: false)
        return OPTIMAL_FIRST_GUESS if first_guess? && !disable_optimizations
        return @remaining_words.list.first if @remaining_words.length == 1

        best_guess = nil
        best_guess_remaining = Float::INFINITY

        guesses = if disable_optimizations
                    Solver::ALLOWED_GUESSES.shuffle
                  elsif @remaining_words.length > 30
                    Solver::ALLOWED_GUESSES.shuffle.first(500)
                  else
                    Game::WORDS
                  end

        progressbar = ProgressBar.create(total: guesses.length, format: '%t: (%c/%C) |%W| %e')
        guesses.each do |guess|
          progressbar.increment

          total = each_possible_clue
            .map { |clue| @remaining_words.filter(guess, clue).length }
            .keep_if { |score| score > 0 ? score : nil }
            .sort

          next if total.empty? # no clues are valid?

          if total[-1] < best_guess_remaining
            puts "New best guess: #{guess}, worst case #{total[-1]}"
            best_guess = guess
            best_guess_remaining = total[-1]
          elsif total[-1] == best_guess_remaining
            puts "Tied guess: #{guess}"
          end

          if best_guess_remaining == 1
            return best_guess
          end
        end

        best_guess
      rescue Interrupt
        sleep 0.5
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
    end
  end
end
