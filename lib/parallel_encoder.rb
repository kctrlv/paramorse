module ParaMorse
  class ParallelEncoder
    def encode_from_file(input_filename, num_files, output_filename)
      #Args: str.txt, int, str*.txt
      tools = Tools.new
      # tools.gen_file(input_filename, true)
      source_text = tools.read_file(input_filename, true)
      encoder = Encoder.new
      encoded_text = encoder.encode(source_text)

      out_prefix = output_filename.split("*")[0]
      out_suffix = output_filename.split("*")[1]

      encoded_chunks = encoded_text.chars.each_slice(num_files).to_a

      n = 0
      num_files.times do
        out_middle = n.to_s.rjust(2,'0')
        this_filename = out_prefix + out_middle + out_suffix
        this_data = encoded_chunks.map{|chunk|chunk[n]}.join
        this_file = File.open("./texts/#{this_filename}", 'w')
        this_file.write(this_data)
        this_file.close
        n+=1
      end
    end
  end
end
