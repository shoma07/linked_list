# frozen_string_literal: true

module LinkedList
  # LinkedList::List
  class List
    include Enumerable

    # LinkedList::Node
    class Node
      attr_reader :data
      attr_accessor :next
      attr_accessor :prev

      # @param [Object] data
      # @return [LinkedList::Node]
      def initialize(data)
        @data = data
        @next = nil
        @prev = nil
      end
    end

    private_constant :Node

    class << self
      # @param [Array] array
      # @return [LinkedList::List]
      def from_array(array)
        l = new
        array.each do |data|
          l.append(data)
        end
        l
      end
    end

    # @param [Object] data
    # @return [LinkedList::List]
    def initialize(data = nil)
      @length = 0
      append(data) if data
    end

    def each(&block)
      if block
        node = @head
        while node
          block.call(node.data)
          node = node.next != @head ? node.next : nil
        end
      end

      self
    end

    # @param [Integer] nth
    # @return [Object]
    # @return [NilClass]
    def at(nth)
      at_node(nth)&.data
    end

    # @return [Object]
    # @return [NilClass]
    def first
      @head&.data
    end

    # @return [Object]
    # @return [NilClass]
    def last
      @head.prev&.data
    end

    # @param [Object] data
    # @return [LinkedList::List]
    def append(data)
      if @head
        @head.prev.next = Node.new(data)
        @head.prev.next.prev = @head.prev
        @head.prev.next.next = @head
        @head.prev = @head.prev.next
      else
        @head = Node.new(data)
        @head.next = @head
        @head.prev = @head
      end
      len_increment

      self
    end

    # @param [Integer] nth
    # @param [Object] obj
    # @return [LinkedList::List]
    # @raise [IndexError]
    def insert(nth, obj)
      node = at_node(nth)
      return raise IndexError unless node

      if node == @head
        unshift(obj)
      else
        node.prev.next = Node.new(obj)
        node.prev.next.prev = node.prev
        node.prev.next.next = node
        node.prev = node.prev.next
        len_increment
      end

      self
    end

    # @return [NilClass]
    def clear
      @head = nil
    end

    # @param [Integer] pos
    # @return [Object]
    # @return [NilClass]
    def delete_at(pos)
      node = at_node(pos)
      return unless node

      data = nil
      if node == @head
        data = shift
      else
        data = node&.data
        node.prev.next = node.next
        node.next.prev = node.prev
        len_decrement
      end

      data
    end

    attr_reader :length

    # @return [Object]
    # @return [NilClass]
    def shift
      return unless @head

      data = @head&.data
      @head.prev.next = @head.next
      @head.next.prev = @head.prev
      @head = @head.next
      len_decrement
      data
    end

    # @param [Object] obj
    # @return [LinkedList::List]
    def unshift(obj)
      append(obj)
      @head = @head.prev

      self
    end

    private

    # @param [Integer] nth
    # @param [Node] node
    def at_node(nth)
      idx = nth.negative? ? length + nth : nth
      return if idx.negative? || idx > length - 1

      node = @head
      if idx > length / 2
        until idx == length
          idx += 1
          node = node.prev
        end
      else
        until idx.zero?
          idx -= 1
          node = node.next
        end
      end

      node
    end

    # @return [Integer]
    def len_increment
      @length += 1
    end

    # @return [Integer]
    def len_decrement
      @length -= 1
    end

    alias push append
    alias << append
    alias [] at
    alias size length
    alias prepend unshift
  end
end
