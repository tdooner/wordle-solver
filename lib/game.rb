module WordleInterviewQ
  class Game
    attr_reader :word

    WORDS = File.read(File.expand_path('../../words.txt', __FILE__)).lines.map(&:strip).map(&:upcase)

    def initialize(word: WORDS.sample.upcase)
      @word = word
    end

    # Returns a string like "NNYGG" where N = not in word, Y = yellow (in word,
    # wrong position), G = (right position)
    def guess(guessed_word)
      raise 'No guess provided' if guessed_word.nil? || guessed_word == ''
      guessed_word = guessed_word.upcase
      return 'GOT IT' if guessed_word == @word

      clued_letters = @word.dup.chars
      clue = Array.new(5)

      # Give clues for green letters first
      guessed_word.chars.each_with_index do |guessed_letter, i|
        if @word[i] == guessed_letter
          clue[i] = 'G'
          clued_letters[i] = nil
        end
      end

      # Then give clues for yellow letters
      guessed_word.chars.each_with_index do |guessed_letter, i|
        next if clue[i] == 'G'
        if (clue_index = clued_letters.find_index(guessed_letter))
          clued_letters[clue_index] = nil
          clue[i] = 'Y'
        end
      end

      # The remaining letters are 'N'
      clue.map { |clue_letter| clue_letter || 'N' }.join
    end
  end
end
