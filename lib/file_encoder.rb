module ParaMorse
  class FileEncoder
    def encode_read_only(input_filename)
      input_path = "./lib/#{input_filename}"
      data = File.open(input_path, 'r').read.chomp
      e = ParaMorse::Encoder.new
      e.encode(data)
    end

    def encode(input_filename, output_filename)
      input_path = "./lib/#{input_filename}"
      output_path = "./lib/#{output_filename}"
      if !File.exists?(input_path)
        return nil
      else
        data = File.open(input_path, 'r').read.chomp
        e = ParaMorse::Encoder.new
        encoded_data = e.encode(data)
        new_file = File.open(output_path, 'w')
        new_file.write(encoded_data)
        new_file.close
      end
    end
  end
end
