module ParaMorse
  class LetterDecoder
    def letter_is_valid?(*bin_letter)
      accepted = Morse.values
      if bin_letter.length != 1
        false
      elsif bin_letter[0].class != String
        false
      elsif accepted.include?(bin_letter[0]) == false
        false
      else
        true
      end

    end
    def decode(*bin_letter)
      if letter_is_valid?(*bin_letter)
        bin_letter = bin_letter[0]
        Morse.key(bin_letter)
      end
    end
  end
end
