module ParaMorse
  class ParallelDecoder
    def decode_from_files(num_files, input_filename, output_filename)
      #Args int, str*.txt, str.txt
      tools = Tools.new
      decoder = Decoder.new
      in_prefix = input_filename.split("*")[0]
      in_suffix = input_filename.split("*")[1]

      data = nil
      n = 0
      num_files.times do
        in_middle = n.to_s.rjust(2,'0')
        this_filename = in_prefix + in_middle + in_suffix
        this_file = tools.read_file(this_filename, true)
        if n == 0
          data = this_file.chars
        else
          data = data.zip(this_file.chars)
        end
        n += 1
      end

      encoded_text = data.flatten.join
      decoded_text = decoder.decode(encoded_text)

      f = File.open("./texts/#{output_filename}", 'w')
      f.write(decoded_text)
      f.close
    end
  end
end
