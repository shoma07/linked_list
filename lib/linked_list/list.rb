# frozen_string_literal: true

module LinkedList
  # LinkedList::List
  class List
    include Enumerable

    # LinkedList::Node
    class Node
      # @!attribute [r] item
      # @return [Object]
      attr_reader :item
      # @!attribute [rw] next
      # @return [Object]
      attr_accessor :next
      # @!attribute [rw] prev
      # @return [Object]
      attr_accessor :prev

      # @param item [Object]
      # @return [LinkedList::Node]
      def initialize(item)
        @item = item
      end

      # @param prev [Node]
      # @param nxt [Node]
      # @return [void]
      def assign(prev, nxt)
        @prev = prev
        @next = nxt
      end
    end

    private_constant :Node

    class << self
      # @param array [Array]
      # @return [LinkedList::List]
      def from_array(array)
        array.each_with_object(new) { |item, result| result.append(item) }
      end
    end

    # @!attribute [r] length
    # @return [Integer]
    attr_reader :length

    # @param item [Object]
    # @return [LinkedList::List]
    def initialize(item = nil)
      item&.then { |i| append(i) }
      self.length = 0
    end

    # @param block [Proc]
    # @return [void]
    def each
      return self unless block_given?

      loop.inject(head) do |node, _i|
        break unless node

        yield(node.item)
        node.next == head ? break : node.next
      end
    end

    # @param nth [Integer]
    # @return [Object, nil]
    def at(nth)
      at_node(nth)&.item
    end

    # @return [Object, nil]
    def first
      head&.item
    end

    # @return [Object, nil]
    def last
      head&.prev&.item
    end

    # @param item [Object]
    # @return [LinkedList::List]
    def append(item)
      head&.then do |node|
        node.prev.next = Node.new(item).tap { |nd| nd.assign(node.prev, node) }
        node.prev = node.prev.next
      end || init_head(item)
      increment
      self
    end

    # @param nth [Integer]
    # @param obj [Object]
    # @return [LinkedList::List]
    # @raise [IndexError]
    def insert(nth, obj)
      at_node(nth)&.then do |node|
        next unshift(obj) if node == head

        node.prev.next = Node.new(obj).tap { |new_node| new_node.assign(node.prev, node) }
        node.prev = node.prev.next
        increment
      end || (raise IndexError)
      self
    end

    # @return [nil]
    def clear
      self.head = nil
    end

    # @param pos [Integer]
    # @return [Object, nil]
    def delete_at(pos)
      at_node(pos)&.then do |node|
        next shift if node == head

        decrement
        node.item.tap do
          node.prev.next = node.next
          node.next.prev = node.prev
        end
      end
    end

    # @return [Object, nil]
    def shift
      head&.then do |node|
        node.item.tap do
          decrement
          node.prev.next = node.next
          node.next.prev = node.prev
          self.head = node.next
        end
      end
    end

    # @param obj [Object]
    # @return [LinkedList::List]
    def unshift(obj)
      append(obj)
      self.head = head.prev
      self
    end

    private

    # @!attribute [rw] head
    # @return [Node]
    attr_accessor :head
    # @!attribute [w] length
    # @return [Integer]
    attr_writer :length

    # @param item [Object]
    # @return [Node]
    def init_head(item)
      self.head = Node.new(item).tap { |node| node.assign(node, node) }
    end

    # @param nth [Integer]
    # @return node [Node]
    def at_node(nth)
      length.then do |len|
        (nth.negative? ? len + nth : nth).then do |idx|
          next if idx.negative? || idx > len - 1

          idx.upto(length - 1).inject(head) { |result, _i| result.prev }
        end
      end
    end

    # @return [Integer]
    def increment
      self.length += 1
    end

    # @return [Integer]
    def decrement
      self.length -= 1
    end

    alias push append
    alias << append
    alias [] at
    alias size length
    alias prepend unshift
  end
end
