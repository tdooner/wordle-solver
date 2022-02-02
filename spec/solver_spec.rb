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
  end

  describe '#matches_clue?' do
    it 'returns the right answers' do
      solver = described_class.new(nil)
      expect(solver.send(:matches_clue?, 'PARTY', 'PXXXX', 'GNNNN')).to eq(true)
      expect(solver.send(:matches_clue?, 'PARTY', 'PAAXX', 'GGNNN')).to eq(true)
      expect(solver.send(:matches_clue?, 'PARTY', 'PXXXA', 'GNNNY')).to eq(true)
      expect(solver.send(:matches_clue?, 'PARTY', 'PATXX', 'GGYNN')).to eq(true)
      expect(solver.send(:matches_clue?, 'PARTY', 'XXYXX', 'NNYNN')).to eq(true)
      expect(solver.send(:matches_clue?, 'HAREM', 'RAZER', 'YGNGN')).to eq(true)
      expect(solver.send(:matches_clue?, 'CATTY', 'XTTXX', 'NYGNN')).to eq(true)
      expect(solver.send(:matches_clue?, 'PARTY', 'PXXTX', 'GNNYN')).to eq(false)
      expect(solver.send(:matches_clue?, 'PARTY', 'PXXXX', 'NNNNN')).to eq(false)
    end
  end
end
