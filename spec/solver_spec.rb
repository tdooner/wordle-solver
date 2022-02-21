require 'spec_helper'

RSpec.describe WordleInterviewQ::Solver do
  describe '#receive_clue' do
    it 'filters out remaining possible words' do
      solver = described_class.new(nil)
      expect(solver.remaining_words).to include('PARTY')
      solver.receive_clue('PXXXX', 'NNNNN')
      expect(solver.remaining_words).not_to include('PARTY')
    end

    it 'filters out remaining guesses' do
      solver = described_class.new(nil)
      expect(solver.remaining_guesses).to include('PARTY')
      solver.receive_clue('PXXXX', 'NNNNN')
      expect(solver.remaining_guesses).not_to include('PARTY')
    end

    it 'filters out yellows that should be greens' do
      solver = described_class.new(nil)
      expect(solver.remaining_guesses).to include('LEDGE')
      solver.receive_clue('RAISE', 'NNNNY')
      expect(solver.remaining_guesses).not_to include('LEDGE')
    end
  end
end
