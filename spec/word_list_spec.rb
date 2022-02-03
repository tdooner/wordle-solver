require 'spec_helper'

RSpec.describe WordleInterviewQ::WordList do
  describe '#filter' do
    let(:list) { ['PARTY'] }

    subject { described_class.new(list) }

    it 'does not remove for simple green clues' do
      expect(subject.filter('PXXXX', 'GNNNN')).to include('PARTY')
      expect(subject.filter('PAAXX', 'GGNNN')).to include('PARTY')
    end

    it 'does not remove for simple yellow clues' do
      expect(subject.filter('PXXXA', 'GNNNY')).to include('PARTY')
      expect(subject.filter('PATXX', 'GGYNN')).to include('PARTY')
      expect(subject.filter('XXYXX', 'NNYNN')).to include('PARTY')
    end

    it 'removes the word for simple clues' do
      expect(subject.filter('PXXTX', 'GNNYN').list).to be_empty
      expect(subject.filter('PXXXX', 'NNNNN').list).to be_empty
    end

    context 'when the clue has repeated letters (Y/N)' do
      let(:list) { ['HAREM'] }

      it 'does not remove the word' do
        expect(subject.filter('RAZER', 'YGNGN')).to include('HAREM')
      end
    end

    context 'when the clue has repeated letters (G/Y)' do
      let(:list) { ['CATTY'] }

      it 'does not remove the word' do
        expect(subject.filter('XTTXX', 'NYGNN')).to include('CATTY')
      end
    end
  end
end
