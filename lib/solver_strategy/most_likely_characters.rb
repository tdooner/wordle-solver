module WordleInterviewQ
  module SolverStrategy
    class MostLikelyCharacters < Base
      def choose_guess
        character_counts = @remaining_guesses.list.flat_map(&:chars).tally
        best_words = @remaining_guesses.list.sort_by do |guess|
          guess.chars.uniq.sum { |guess_char| Math.log(character_counts.fetch(guess_char, 1)) }
        end.reverse

        best_words.first
      end
    end
  end
end
