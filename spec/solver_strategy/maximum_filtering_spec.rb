require 'spec_helper'

RSpec.describe WordleInterviewQ::SolverStrategy::MaximumFiltering do
  describe '#choose_guess' do
    it 'does the right thing' do
      game = WordleInterviewQ::Game.new(word: 'FLESH')
      solver = WordleInterviewQ::Solver.new(game, described_class)
      clue = game.guess('RAISE')
      expect(clue).to eq('NNNGY')
      solver.receive_clue('RAISE', clue)

      solver.make_guess
    end
  end
end
