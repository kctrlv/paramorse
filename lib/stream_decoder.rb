module ParaMorse
  class StreamDecoder
    attr_accessor :queue

    def initialize
      @queue = ParaMorse::Queue.new
    end

    def receive(bit)
      @queue.push(bit)
    end

    def decode
      d = ParaMorse::Decoder.new
      if @queue.tail == '0'
        @queue.pop
      end
      bin_data = @queue.join
      d.decode(bin_data)
    end
  end
end
