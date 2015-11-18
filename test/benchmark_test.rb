require_relative '../test/test_helper'
require 'minitest/benchmark'

class Test < Minitest::Benchmark
  def self.bench_range
    # 10万、100万、1000万とテストの件数（配列の要素数）を増やす
    bench_exp 100_000, 10_000_000
  end

  def bench_bsearch_index
    results = []
    # bsearch_index と index の実行結果を保存する
    validation = ->(range, times) { results << times }

    # bsearch_indexを使って末尾の要素を探す
    assert_performance(validation) do |n|
      [*0..n].bsearch_index { |item| item == n }
    end

    # indexを使って末尾の要素を探す
    assert_performance(validation) do |n|
      [*0..n].index { |item| item == n }
    end

    # bsearch_index の方が index よりも毎回速いことを検証する
    assert results.transpose.all? { |binary, linear| binary < linear }
  end
end