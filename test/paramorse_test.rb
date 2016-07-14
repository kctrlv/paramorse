require 'minitest/autorun'
require 'minitest/pride'
require './lib/paramorse'
require './lib/queue'
require './lib/letter_encoder'
require './lib/letter_decoder'
require './lib/encoder'
require './lib/decoder'
require './lib/stream_decoder'
require './lib/file_encoder'
require './lib/file_decoder'

class QueueTest < Minitest::Test
  def test_it_exists
    assert q = ParaMorse::Queue.new
  end

  def test_it_pushes_bit
    q = ParaMorse::Queue.new
    assert q.push('1')
    assert q.push('0')
  end

  def test_it_refutes_pushing_invalid_bits
    q = ParaMorse::Queue.new
    refute q.push('2')
    refute q.push('b')
    refute q.push('$')
    refute q.push('01')
    refute q.push('0','1')
    refute q.push('')
    refute q.push
  end

  def test_it_reports_single_tail
    q = ParaMorse::Queue.new
    q.push('1')
    q.push('0')
    q.push('0')
    q.push('1')
    q.push('1')
    assert_equal '1', q.tail
  end

  def test_it_reports_many_tails
    q = ParaMorse::Queue.new
    q.push('1')
    q.push('0')
    q.push('0')
    q.push('1')
    q.push('1')
    assert_equal ['1','1','0'], q.tail(3)
    q.push('0')
    assert_equal ['0','1','1'], q.tail(3)
    assert_equal ['0','1','1','0'], q.tail(4)
  end

  def test_it_refutes_invalid_tails
    q = ParaMorse::Queue.new
    refute q.tail
    refute q.tail(3)
    refute q.tail('x')
    q.push('1')
    refute q.tail('x')
    refute q.tail('1','x')
    refute q.tail(1,0)

  end

  def test_it_peeks_at_one
    q = ParaMorse::Queue.new
    q.push('1')
    q.push('0')
    q.push('0')
    q.push('1')
    q.push('1')
    assert_equal '1', q.peek
  end

  def test_it_peeks_at_many
    q = ParaMorse::Queue.new
    q.push('1')
    q.push('0')
    q.push('0')
    q.push('1')
    q.push('1')
    assert_equal ['1','0','0'], q.peek(3)
    assert_equal ['1','0'], q.peek(2)
  end

  def test_it_refutes_peeking_invalidly
    q = ParaMorse::Queue.new
    refute q.peek
    refute q.peek(0)
    refute q.peek(1)
    refute q.peek('1')
    refute q.peek('z')
    refute q.peek('%5')
    q.push('1')
    q.push('0')
    q.push('1')
    refute q.peek('2')
    refute q.peek('red')
    refute q.peek(3.45)
    refute q.peek(1,0)
  end

  def test_it_counts
    q = ParaMorse::Queue.new
    assert_equal 0, q.count
    q.push('1')
    q.push('0')
    q.push('0')
    q.push('1')
    q.push('1')
    assert_equal 5, q.count
  end

  def test_it_refutes_invalid_count_calls
    q = ParaMorse::Queue.new
    refute q.count(2)
    refute q.count('zebra')
    refute q.count(0,1)
  end

  def test_it_pops_one_and_many
    q = ParaMorse::Queue.new
    q.push('1')
    q.push('0')
    q.push('0')
    q.push('1')
    q.push('1')
    assert_equal '1', q.pop
    assert_equal ['1','0','0'], q.pop(3)
    assert_equal 1, q.count
    assert_equal '1', q.pop
  end

  def test_it_refutes_invalid_pops
    q = ParaMorse::Queue.new
    refute q.pop
    q.push('1')
    refute q.pop('giraffe')
    refute q.pop({'color'=>'blue'})
    refute q.pop(0,1)
  end

  def test_it_clears
    q = ParaMorse::Queue.new
    q.push('1')
    q.push('0')
    q.push('0')
    q.push('1')
    q.push('1')
    q.clear
    assert_equal 0, q.count
  end

  def test_it_refutes_invalid_clear_calls
    q = ParaMorse::Queue.new
    q.push('1')
    refute q.clear(10)
    refute q.clear(['bob'])
  end

  def test_it_knows_its_empty
    q = ParaMorse::Queue.new
    assert q.empty?
    q.push('1')
    refute q.empty?
    q.clear
    assert q.empty?
  end
end

class LetterEncoderTest < Minitest::Test
  def test_it_exists
    assert ParaMorse::LetterEncoder.new
  end

  def test_it_knows_which_letters_are_valid
    l = ParaMorse::LetterEncoder.new
    assert_equal true, l.letter_is_valid?("a")
    assert_equal true, l.letter_is_valid?("z")
    assert_equal true, l.letter_is_valid?("n")
    assert_equal true, l.letter_is_valid?("1")
    assert_equal true, l.letter_is_valid?("8")
    assert_equal true, l.letter_is_valid?(" ")
    assert_equal false, l.letter_is_valid?("bob")
    assert_equal false, l.letter_is_valid?(3)
    assert_equal false, l.letter_is_valid?([])
    assert_equal false, l.letter_is_valid?(1,'2',['three'])
    assert_equal false, l.letter_is_valid?("")
    assert_equal false, l.letter_is_valid?
  end

  def test_it_encodes_letter
    l = ParaMorse::LetterEncoder.new
    a = l.encode("a")
    q = l.encode("q")
    assert_equal '10111', a
    assert_equal '1110111010111', q
  end

  def test_it_refutes_encoding_invalid_letters
    l = ParaMorse::LetterEncoder.new
    refute l.encode(3)
    refute l.encode("!")
    refute l.encode("bob")
    refute l.encode(1,'2','three')
    refute l.encode([])
  end
end

class LetterDecoderTest < Minitest::Test
  def test_it_exists
    assert ParaMorse::LetterDecoder.new
  end

  def test_it_knows_which_letters_are_valid
    d = ParaMorse::LetterDecoder.new
    assert_equal true, d.letter_is_valid?("1010101")
    assert_equal true, d.letter_is_valid?("1010111")
    assert_equal true, d.letter_is_valid?("11101010111")
    assert_equal true, d.letter_is_valid?("101010101")
    assert_equal true, d.letter_is_valid?("111011101110101")
    assert_equal true, d.letter_is_valid?("000000")
    assert_equal false, d.letter_is_valid?("11")
    assert_equal false, d.letter_is_valid?(11)
    assert_equal false, d.letter_is_valid?([])
    assert_equal false, d.letter_is_valid?(0,0,0)
    assert_equal false, d.letter_is_valid?("")
    assert_equal false, d.letter_is_valid?
  end

  def test_it_decodes_letter
    d = ParaMorse::LetterDecoder.new
    a = d.decode("10111")
    q = d.decode("1110111010111")
    assert_equal 'a', a
    assert_equal 'q', q
  end

  def test_it_refutes_decoding_invalid_letters
    d = ParaMorse::LetterDecoder.new
    refute d.decode(3)
    refute d.decode("1111")
    refute d.decode("bob")
    refute d.decode(1,'2','three')
    refute d.decode([])
  end
end

class EncoderTest < Minitest::Test
  def test_it_exists
    assert e = ParaMorse::Encoder.new
  end

  def test_it_knows_which_words_are_valid
    e = ParaMorse::Encoder.new
    assert_equal true, e.word_is_valid?('word')
    assert_equal true, e.word_is_valid?('bob')
    assert_equal true, e.word_is_valid?('STEVE')
    assert_equal true, e.word_is_valid?('012')
    assert_equal true, e.word_is_valid?('0 1 2')
    assert_equal false, e.word_is_valid?(1)
    assert_equal false, e.word_is_valid?('1','2')
    assert_equal false, e.word_is_valid?([])
    assert_equal false, e.word_is_valid?()
  end

  def test_it_encodes_word
    e = ParaMorse::Encoder.new
    assert_equal '1011101110001110111011100010111010001110101', e.encode('word')
  end

  def test_it_refutes_invalid_words
    e = ParaMorse::Encoder.new
    refute e.encode(3)
    refute e.encode([])
    refute e.encode('1',2,'three')
  end

  def test_it_encodes_multiple_words
    e = ParaMorse::Encoder.new
    assert_equal "10111000000010111", e.encode("a a")
    assert_equal "10111000000011101110001110111011100010111010001010100010000000111000100010101000111", e.encode("a morse test")
  end
end

class DecoderTest < Minitest::Test
  def test_it_exists
    assert d = ParaMorse::Decoder.new
  end

  def test_it_knows_which_bin_words_are_valid
    d = ParaMorse::Decoder.new
    assert_equal true, d.bin_word_is_valid?('1011101110001110111011100010111010001110101')
    assert_equal false, d.bin_word_is_valid?(1)
    assert_equal false, d.bin_word_is_valid?('1','2')
    assert_equal false, d.bin_word_is_valid?([])
    assert_equal false, d.bin_word_is_valid?()
    assert_equal false, d.bin_word_is_valid?("word")
  end

  def test_it_decodes_word_and_multiple_words
    d = ParaMorse::Decoder.new
    assert_equal "word", d.decode('1011101110001110111011100010111010001110101')
    assert_equal "a a", d.decode('10111000000010111')
    assert_equal "a morse test", d.decode('10111000000011101110001110111011100010111010001010100010000000111000100010101000111')
  end

  def test_it_refutes_invalid_words
    d = ParaMorse::Decoder.new
    refute d.decode(3)
    refute d.decode([])
    refute d.decode('1',2,'three')
    refute d.decode("word")
  end
end

class StreamDecoderTest < Minitest::Test
  def test_it_exists
    assert ParaMorse::StreamDecoder.new
  end

  def test_it_records_and_decodes_bits
    s = ParaMorse::StreamDecoder.new
    s.receive("1")
    s.receive("0")
    s.receive("1")
    s.receive("0")
    s.receive("1")
    s.receive("0")
    s.receive("1")
    s.receive("0")
    s.receive("0")
    s.receive("0")
    s.receive("1")
    s.receive("0")
    s.receive("1")
    s.receive("0")
    assert_equal 'hi', s.decode
  end
end

class FileEncoderTest < Minitest::Test
  def test_it_exists
    assert ParaMorse::FileEncoder.new
  end

  def test_it_can_encode_data_from_file #but not yet write to output file
    f = ParaMorse::FileEncoder.new
    assert_equal '10111000000011101110001110111011100010111010001010100010000000111000100010101000111', f.encode_read_only('plain.txt')
  end

  def test_it_can_encode_and_write_to_file
    f = ParaMorse::FileEncoder.new
    encoded_data = '10111000000011101110001110111011100010111010001010100010000000111000100010101000111'
    random_suffix = (1..8).map{|n|('A'..'Z').to_a.sample}.join
    f.encode("plain.txt", "test-#{random_suffix}.txt")
    assert_equal encoded_data, File.open("./lib/test-#{random_suffix}.txt").read
    File.delete("./lib/test-#{random_suffix}.txt")
  end

  def test_it_can_handle_nonexistent_file
    f = ParaMorse::FileEncoder.new
    f.encode("nonexistent.txt", "some_output.txt")
    refute File.exists?("./nonexistent.txt")
    f.encode("plain.txt", "some_real_output.txt")
    assert File.exists?("./lib/some_real_output.txt")
    File.delete("./lib/some_real_output.txt")
  end

  def test_it_encodes_speech
    f = ParaMorse::FileEncoder.new
    f.encode("obama_speech_plain.txt", "obama_speech_morse.txt")
    assert File.exists?("./lib/obama_speech_morse.txt")
    File.delete("./lib/obama_speech_morse.txt")
  end
end

class FileDecoderTest < Minitest::Test
  def test_it_exists
    assert ParaMorse::FileDecoder.new
  end

  def test_it_can_decode_data_from_file #but not yet write to output file
    f = ParaMorse::FileDecoder.new
    assert_equal 'a morse test', f.decode_read_only('encoded.txt')
  end

  def test_it_can_decode_and_write_to_file
    f = ParaMorse::FileDecoder.new
    decoded_data = 'a morse test'
    random_suffix = (1..8).map{|n|('A'..'Z').to_a.sample}.join
    f.decode("encoded.txt", "test-#{random_suffix}.txt")
    assert_equal decoded_data, File.open("./lib/test-#{random_suffix}.txt").read
    File.delete("./lib/test-#{random_suffix}.txt")
  end

  def test_it_can_handle_nonexistent_file
    f = ParaMorse::FileDecoder.new
    f.decode("nonexistent.txt", "some_output.txt")
    refute File.exists?("./nonexistent.txt")
    f.decode("encoded.txt", "some_real_output.txt")
    assert File.exists?("./lib/some_real_output.txt")
    File.delete("./lib/some_real_output.txt")
  end

  def test_it_can_decode_speech
    f = ParaMorse::FileDecoder.new
    f.decode("obama_speech_morse.txt", "obama_speech_plain_converted.txt")
    assert File.exists?("./lib/obama_speech_plain_converted.txt")
    File.delete("./lib/obama_speech_plain_converted.txt")
  end
end
