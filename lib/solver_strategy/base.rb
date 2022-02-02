module WordleInterviewQ
  module SolverStrategy
    autoload :Random, './lib/solver_strategy/random.rb'

    class Base
      def initialize(solver, remaining_words, remaining_guesses)
        @solver = solver
        @remaining_words = remaining_words
        @remaining_guesses = remaining_guesses
      end

      def choose_guess
        raise NotImplementedError
      end
    end
  end
end
