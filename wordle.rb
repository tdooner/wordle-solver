class Wordle
  WORDS = File.read(File.expand_path('./words.txt')).lines.map(&:strip)

  def initialize(word: WORDS.sample)
    @word = word
    puts "the word is #{@word}"
  end

  # Returns a string like "NNYGG" where N = not in word, Y = yellow (in word,
  # wrong position), G = (right position)
  def guess(guessed_word)
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

def test_game_logic
  puts 'Testing...'
  game = Wordle.new(word: 'PARTY')
  puts(game.guess('PARSE').inspect + " (should be GGGNN)")
  puts(game.guess('CAPER').inspect + " (should be NGYNY)")
  puts(game.guess('CARRY').inspect + " (should be NGGNG)")
  puts(game.guess('RRRRR').inspect + " (should be NNGNN)")
  puts(game.guess('PARTY').inspect + " (should be GOT IT)")
  puts(Wordle.new(word: 'DELVE').guess('NEBEL').inspect + " (should be NGNYY)")
end

class Solver
  ALLOWED_GUESSES = File.read(File.expand_path('./wordle-allowed-guesses.txt')).lines.map(&:strip)

  def initialize(game)
    @remaining_words = Wordle::WORDS.dup
    @remaining_guesses = ALLOWED_GUESSES | @remaining_words
    @game = game
  end

  # Returns the guessed word
  def solve
    loop do
      guess = @remaining_guesses.sample
      puts "Remaining words: #{@remaining_words.length} / Remaining guesses: #{@remaining_guesses.length} / Guessing #{guess}"
      return guess if (clue = @game.guess(guess)) == 'GOT IT'

      puts "  got #{clue}"

      filter_word_list!(@remaining_words, guess, clue)
      filter_word_list!(@remaining_guesses, guess, clue)
    end
  end

  private

  def filter_word_list!(list, guess, clue)
    list.filter! { |word| matches_clue?(word, guess, clue) }
  end

  def matches_clue?(word, guess, clue)
    word_letters = word.chars

    # Reject words missing 'G' letters
    clue.chars.each_with_index do |clue_char, i|
      next unless clue_char == 'G'

      return false unless word[i] == guess[i]
      word_letters[i] = nil
    end

    # Reject words with 'N' letters
    clue.chars.each_with_index do |clue_char, i|
      next unless clue_char == 'N'

      return false if word_letters.include?(guess[i])
    end

    # Reject words without remaining 'Y' letters
    clue.chars.each_with_index do |clue_char, i|
      next unless clue_char == 'Y'

      return false unless (clue_index = word_letters.index(guess[i])) && clue_index != i
      word_letters[clue_index] = nil
    end

    true
  end
end

def test_solver
  puts "Testing Solver..."
  game = Wordle.new
  solver = Solver.new(game)
  puts solver.send(:matches_clue?, 'PARTY', 'PXXXX', 'GNNNN').inspect + " (= true)"
  puts solver.send(:matches_clue?, 'PARTY', 'PXXXA', 'GNNNY').inspect + " (= true)"
  puts solver.send(:matches_clue?, 'PARTY', 'PAAXX', 'GGNNN').inspect + " (= true)"
  puts solver.send(:matches_clue?, 'PARTY', 'PATXX', 'GGYNN').inspect + " (= true)"
  puts solver.send(:matches_clue?, 'PARTY', 'XXYXX', 'NNYNN').inspect + " (= true)"
  puts solver.send(:matches_clue?, 'CATTY', 'XTTXX', 'NYGNN').inspect + " (= true)"
  puts solver.send(:matches_clue?, 'PARTY', 'PXXTX', 'GNNYN').inspect + " (= false)"
  puts solver.send(:matches_clue?, 'PARTY', 'PXXXX', 'NNNNN').inspect + " (= false)"
end

# test_game_logic

game = Wordle.new
solver = Solver.new(game)
answer = solver.solve
puts "Answer: #{answer}"
