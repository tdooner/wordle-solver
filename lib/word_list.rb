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
      clue_chars = clue.chars

      # Reject words missing 'G' letters
      clue_chars.each_with_index do |clue_char, i|
        next unless clue_char == 'G'

        return false unless word[i] == guess[i]
        word_letters[i] = nil
      end

      # Reject words without remaining 'Y' letters
      clue_chars.each_with_index do |clue_char, i|
        next unless clue_char == 'Y'

        return false unless (clue_index = word_letters.index(guess[i])) && clue_index != i
        word_letters[clue_index] = nil
      end

      # Reject words with 'N' letters
      clue_chars.each_with_index do |clue_char, i|
        next unless clue_char == 'N'

        return false if word_letters.include?(guess[i])
      end

      true
    end
  end
end
