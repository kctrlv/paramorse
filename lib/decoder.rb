module ParaMorse
  class Decoder
    def bin_word_is_valid?(*bin_word)
      if bin_word.length != 1
        false
      elsif bin_word[0].class != String
        false
      elsif bin_word[0].length < 1
        false
      elsif !bin_word[0].chars.all? { |char| ['1','0'].include?(char) }
        false
      else
        true
      end
    end

    def decode(*bin_word)
      if bin_word_is_valid?(*bin_word)
        bin_word = bin_word[0]
        d = LetterDecoder.new
        bin_words = bin_word.split("0000000")
        solved_words = []
        bin_words.each do |bin_word|
          bin_letters = bin_word.split("000")
          solved_words << bin_letters.map{ |bin_letter| d.decode(bin_letter)}.join
        end
        solved_words.join(" ")
      end
    end
  end
end
