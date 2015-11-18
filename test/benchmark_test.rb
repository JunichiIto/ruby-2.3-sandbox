require_relative '../test/test_helper'
require 'minitest/benchmark'

class Test < Minitest::Benchmark
  def self.bench_range
    bench_exp 100_000, 10_000_000
  end

  def bench_bsearch_index
    results = []
    validation = ->(range, times) { results << times }

    assert_performance(validation) do |n|
      array = [*0..n]
      target = n
      array.bsearch_index { |item| item == target }
    end

    assert_performance(validation) do |n|
      array = [*0..n]
      target = n
      array.index { |item| item == target }
    end

    assert results.transpose.all? { |binary, linear| binary < linear }
  end
end