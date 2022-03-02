# frozen_string_literal: true

module WordleInterviewQ
  class WordList
    attr_reader :list

    def initialize(list)
      @list = list
    end

    def filter(guess, clue)
      WordList
        .new(@list.dup)
        .tap { |list| list.filter!(guess, clue) }
    end

    def filter!(guess, clue)
      @list.select! { |word| matches_clue?(word, guess, clue) }
    end

    def length
      @list.length
    end

    def include?(item)
      @list.include?(item)
    end

    def sample
      @list.sample
    end

  private

    def matches_clue?(word, guess, clue)
      word_letters = word.chars

      # Reject words with missing 'G' letters
      return false if clue[0] == 'G' && word[0] != guess[0]
      return false if clue[1] == 'G' && word[1] != guess[1]
      return false if clue[2] == 'G' && word[2] != guess[2]
      return false if clue[3] == 'G' && word[3] != guess[3]
      return false if clue[4] == 'G' && word[4] != guess[4]

      # Reject words with 'Y' letters that should be green
      return false if clue[0] == 'Y' && word[0] == guess[0]
      return false if clue[1] == 'Y' && word[1] == guess[1]
      return false if clue[2] == 'Y' && word[2] == guess[2]
      return false if clue[3] == 'Y' && word[3] == guess[3]
      return false if clue[4] == 'Y' && word[4] == guess[4]

      # Keep track of which letters were used in clues already, so we can use
      # knowledge of the grey squares to eliminate words correctly even when
      # the clue contains the same letter multiple times with different colors.
      5.times do |i|
        case clue[i]
        when 'G'
          word_letters[i] = nil
        when 'Y'
          # Reject words without remaining 'Y' letters or with 'Y' letters that
          # would have been green.
          return false unless (clue_index = word_letters.index(guess[i])) && clue_index != i
          word_letters[clue_index] = nil
        end
      end

      # Reject words with 'N' letters
      5.times do |i|
        next unless clue[i] == 'N'

        return false if word_letters.include?(guess[i])
      end

      true
    end
  end
end
