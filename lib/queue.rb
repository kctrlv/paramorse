module ParaMorse
  class Queue
    attr_accessor :queue

    def initialize
      @queue = []
    end

    def push(*bit)
      if bit.length != 1
        return false
      else
        bit = bit[0]
      end
      @queue << bit if ['0','1'].include?(bit)
    end

    def tail(*n)
      if n.empty?
        @queue.last
      elsif @queue.length == 0
        false
      elsif n[0].class != Fixnum
        false
      elsif n.length != 1
        false
      else
        num_digits = n[0]
        length = @queue.length
        @queue[(length-num_digits)..length].reverse
      end
    end

    def peek(*n)
      if n.empty?
        @queue.first
      elsif @queue.length == 0
        false
      elsif n[0].class != Fixnum
        false
      elsif n.length != 1
        false
      else
        num_digits = n[0]
        @queue[0..(num_digits-1)]
      end
    end

    def count(*x)
      if x.length > 0 #it shouldnt have arguments
        false
      else
        @queue.count
      end
    end

    def pop(*n)
      if n.empty?
        @queue.pop
      elsif @queue.length == 0
        false
      elsif n[0].class != Fixnum
        false
      elsif n.length != 1
        false
      else
        num_digits = n[0]
        @queue.pop(num_digits).reverse
      end
    end

    def clear(*x)
      if x.length > 0
        false
      else
        @queue = []
      end
    end

    def empty?(*x)
      if x.length > 0
        false
      else
        @queue.length == 0
      end
    end

    def join
      @queue.join
    end
  end
end
