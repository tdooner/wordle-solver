require 'spec_helper'

RSpec.describe WordleInterviewQ::Game do
  describe '#guess' do
    it 'puts green characters in the right spots' do
      game = WordleInterviewQ::Game.new(word: 'PARTY')
      expect(game.guess('PANSY')).to eq('GGNNG')
      expect(game.guess('PARSE')).to eq('GGGNN')
    end

    it 'puts yellow characters in the right spots' do
      game = WordleInterviewQ::Game.new(word: 'PARTY')
      expect(game.guess('CAPER')).to eq('NGYNY')
      expect(game.guess('CARRY')).to eq('NGGNG')
      expect(game.guess('RRRRR')).to eq('NNGNN')
    end

    it 'handles multiple characters (green/yellow)' do
      game = WordleInterviewQ::Game.new(word: 'DELVE')
      expect(game.guess('NEBEL')).to eq('NGNYY')
    end

    it 'says GOT IT when you got it' do
      game = WordleInterviewQ::Game.new(word: 'PARTY')
      expect(game.guess('PARTY')).to eq('GOT IT')
    end
  end
end
