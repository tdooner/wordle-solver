module WordleInterviewQ
  module SolverStrategy
    class Random < Base
      def choose_guess
        @remaining_guesses.sample
      end
    end
  end
end
