# frozen_string_literal: true

require 'bundler/setup'
require 'linked_list'
require 'benchmark'

def create_array(size)
  Array.new(size) { |i| i + 1 }
end

def bench(test, method, *args)
  test.each do |origin|
    array = origin.dup
    linked_list = LinkedList::List.from_array(array)
    puts '------------------------------------------------------------------'
    Benchmark.bm 20 do |r|
      r.report "Array      #{array.length}" do
        array.send(method, *args)
      end
      r.report "LinkedList #{linked_list.length}" do
        linked_list.send(method, *args)
      end
    end
  end
end

test = [
  create_array(0),
  create_array(10),
  create_array(100),
  create_array(1000),
  create_array(10_000),
  create_array(100_000),
]

puts '=================================================================='
puts 'append'
bench(test, :append, 1)

puts '=================================================================='
puts 'shift'
bench(test, :shift)

puts '=================================================================='
puts 'unshift'
bench(test, :unshift, 1)

puts '=================================================================='
puts 'at(min cost)'
bench([create_array(0)], :at, 0)
bench([create_array(10)], :at, 9)
bench([create_array(100)], :at, 99)
bench([create_array(1000)], :at, 999)
bench([create_array(10_000)], :at, 9_999)
bench([create_array(100_000)], :at, 99_999)
puts '=================================================================='
puts 'at(max cost)'
bench([create_array(0)], :at, 0)
bench([create_array(10)], :at, 5)
bench([create_array(100)], :at, 50)
bench([create_array(1000)], :at, 500)
bench([create_array(10_000)], :at, 5_000)
bench([create_array(100_000)], :at, 50_000)

puts '=================================================================='
puts 'length'
bench(test, :length)
