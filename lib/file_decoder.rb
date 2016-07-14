module ParaMorse
  class FileDecoder
    def decode_read_only(input_filename)
      input_path = "./lib/#{input_filename}"
      bin_data = File.open(input_path, 'r').read.chomp
      d = ParaMorse::Decoder.new
      d.decode(bin_data)
    end

    def decode(input_filename, output_filename)
      input_path = "./lib/#{input_filename}"
      output_path = "./lib/#{output_filename}"
      if !File.exists?(input_path)
        return nil
      else
        bin_data = File.open(input_path, 'r').read.chomp
        d = ParaMorse::Decoder.new
        decoded_data = d.decode(bin_data)
        new_file = File.open(output_path, 'w')
        new_file.write(decoded_data)
        new_file.close
      end
    end
  end
end
