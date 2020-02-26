# frozen_string_literal: true

module LinkedList
  # LinkedList::List
  class List
    include Enumerable

    # LinkedList::Node
    class Node
      attr_reader :data
      attr_accessor :next

      # @param [Object] data
      # @return [LinkedList::Node]
      def initialize(data)
        @data = data
        @next = nil
      end
    end

    private_constant :Node

    class << self
      # @param [Array] array
      # @return [LinkedList::List]
      def from_array(array)
        l = new
        array.each do |data|
          l.append data
        end
        l
      end
    end

    # @param [Object] data
    # @return [LinkedList::List]
    def initialize(data = nil)
      @head = Node.new(data) if data
    end

    def each
      node = @head
      while node
        yield node.data
        node = node.next
      end

      self
    end

    # @param [Integer] nth
    # @return [Object]
    # @return [NilClass]
    def at(nth)
      i = nth.negative? ? length + nth : nth
      return if i.negative?

      at_node(i, @head)&.data
    end

    # @return [Object]
    # @return [NilClass]
    def first
      @head&.data
    end

    # @return [Object]
    # @return [NilClass]
    def last
      last_node(@head)&.data
    end

    # @param [Object] data
    # @return [LinkedList::List]
    def append(data)
      if @head
        last_node(@head).next = Node.new(data)
      else
        @head = Node.new(data)
      end

      self
    end

    # @param [Integer] nth
    # @param [Object] obj
    # @return [LinkedList::List]
    def insert(nth, obj)
      i = nth.negative? ? length + nth : nth
      raise IndexError if i.negative?

      insert_node = Node.new(obj)
      if i.zero?
        insert_node.next = @head
        @head = insert_node
      else
        n = at_node(i - 1, @head)
        if n
          insert_node.next = n.next
          n.next = insert_node
        end
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
      i = pos.negative? ? length + pos : pos
      data = nil
      if i.zero?
        data = @head&.data
        @head = @head&.next
      else
        n = at_node(i - 1, @head)
        if n
          data = n.next&.data
          n.next = n.next&.next
        end
      end

      data
    end

    # @return [Integer]
    def length
      inject(0) { |i| i + 1 }
    end

    # @return [Object]
    # @return [NilClass]
    def shift
      return unless @head

      data = @head&.data
      @head = @head.next
      data
    end

    # @param [Object] obj
    # @return [LinkedList::List]
    def unshift(obj)
      node = Node.new(obj)
      node.next = @head
      @head = node

      self
    end

    private

    # @param [Integer] nth
    # @param [Node] node
    def at_node(nth, node)
      return if nth.negative? || !node

      nth.zero? ? node : at_node(nth - 1, node&.next)
    end

    # @param [Node] node
    # @return [Node]
    def last_node(node)
      return node unless node&.next

      last_node(node.next)
    end

    alias push append
    alias << append
    alias [] at
    alias size length
    alias prepend unshift
  end
end
