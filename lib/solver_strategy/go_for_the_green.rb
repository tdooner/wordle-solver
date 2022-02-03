module WordleInterviewQ
  module SolverStrategy
    # Reimplemented from:
    # https://medium.com/@tglaiel/the-mathematically-optimal-first-guess-in-wordle-cbcb03c19b0a
    #
    # Rank each guess according to its score, which is the sum for all remaining
    # words, of green and yellow characters (2 and 1 points respectively).
    class GoForTheGreen < Base
      OPTIMAL_FIRST_GUESS = 'SOARE' # assumes 2 points for green, 1 point for yellow

      def choose_guess
        return OPTIMAL_FIRST_GUESS if first_guess?

        best_guess = nil
        best_guess_score = 0

        @remaining_guesses.list.each do |guess|
          score = @remaining_words.list.sum do |word|
            next 10 if word == guess

            clue_score(simulate_guess(word, guess))
          end
          if score > best_guess_score
            best_guess = guess
            best_guess_score = score
          end
        end

        best_guess
      end

      private

      def simulate_guess(word, guess)
        game = Game.new(word: word)
        game.guess(guess)
      end

      def clue_score(clue)
        clue.chars.sum do |char|
          case char
          when 'G'
            2
          when 'Y'
            1
          else
            0
          end
        end
      end
    end
  end
end
