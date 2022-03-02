module WordleInterviewQ
  module SolverStrategy
    autoload :Random, './lib/solver_strategy/random.rb'
    autoload :MostLikelyCharacters, './lib/solver_strategy/most_likely_characters.rb'
    autoload :GoForTheGreen, './lib/solver_strategy/go_for_the_green.rb'
    autoload :MaximumFiltering, './lib/solver_strategy/maximum_filtering.rb'
    autoload :MaximumFilteringQuordle, './lib/solver_strategy/maximum_filtering_quordle.rb'

    class Base
      def initialize(solver, remaining_words, remaining_guesses)
        @solver = solver
        @remaining_words = remaining_words
        @remaining_guesses = remaining_guesses
      end

      def choose_guess
        raise NotImplementedError
      end

      def first_guess?
        @solver.clues.empty?
      end

      def second_guess?
        @solver.clues.length == 1
      end

      def debug(&block)
        block.call if ENV['DEBUG']
      end
    end
  end
end
