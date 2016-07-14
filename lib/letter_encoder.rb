module ParaMorse
  class LetterEncoder
    def letter_is_valid?(*letter)
      accepted = Morse.keys
      if letter.length != 1
        false
      elsif letter[0].class != String
        false
      elsif accepted.include?(letter[0]) == false
        false
      else
        true
      end
    end

    def encode(*letter)
      if letter_is_valid?(*letter)
        letter = letter[0]
        Morse[letter]
      end
    end
  end
end
