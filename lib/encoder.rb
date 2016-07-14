module ParaMorse
  class Encoder
    def word_is_valid?(*word)
      if word.length != 1
        false
      elsif word[0].class != String
        false
      elsif word[0].length < 1
        false
      else
        true
      end
    end

    def encode(*word)
      if word_is_valid?(*word)
        word = word[0]
        e = LetterEncoder.new
        letters = word.downcase.split("")
        pre_solution = letters.map{ |letter| e.encode(letter)}.join("000")
        solution = pre_solution.gsub("000000000000", "0000000")
      end
    end
  end
end
