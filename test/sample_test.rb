require_relative '../test/test_helper'

class SampleTest < Minitest::Test
  def test_hash_dig
    user = {
        user: {
            address: {
                street1: '123 Main street'
            }
        }
    }

    # digを使って深い階層の値を一気に取得する
    assert_equal '123 Main street', user.dig(:user, :address, :street1)

    # Keyが存在する場合は以下のコードと同等
    assert_equal '123 Main street', user[:user][:address][:street1]

    # 存在しないKeyを指定するとnilが返ってくる（エラーは起きない）
    assert_nil user.dig(:user, :adddresss, :street1)

    # 普通に[]を使うとエラーになる
    assert_raises { user[:user][:adddresss][:street1] }
  end

  def test_array_dig
    results = [[[1, 2, 3]]]

    # digを使って深い階層の値を一気に取得する
    assert_equal 1, results.dig(0, 0, 0)

    # Indexが存在する場合は以下のコードと同様
    assert_equal 1, results[0][0][0]

    # 存在しないIndexを指定するとnilが返ってくる（エラーは起きない）
    assert_nil results.dig(1, 1, 1)

    # 普通に[]を使うとエラーになる
    assert_raises { results[1][1][1] }
  end

  # 正規表現 + grep_v を使う場合
  def test_grep_v_by_regex
    friends = %w[John Alain Jim Delmer]

    # Jで始まる文字列を探す
    j_friends = friends.grep(/^J/)
    assert_equal %w(John Jim), j_friends

    # J以外で始まる文字列を探す
    others    = friends.grep_v(/^J/)
    assert_equal %w(Alain Delmer), others
  end

  # # 型情報 + grep_v を使う場合
  def test_grep_v_by_type
    items = [1, 1.0, '1', nil]

    # Numeric型のオブジェクトを探す
    nums   = items.grep(Numeric)
    assert_equal [1, 1.0], nums

    # Numeric型以外のオブジェクトを探す
    others = items.grep_v(Numeric)
    assert_equal ['1', nil], others
  end

  def test_fetch_values
    values = {
        foo: 1,
        bar: 2,
        baz: 3,
        qux: 4
    }

    # Keyが存在する場合は values_at も fetch_values も同じ結果を返す
    assert_equal [1, 2], values.values_at(:foo, :bar)
    assert_equal [1, 2], values.fetch_values(:foo, :bar)

    # Keyが存在しない場合、 values_at は nil を返す
    assert_equal [1, 2, nil], values.values_at(:foo, :bar, :invalid)

    # Keyが存在しない場合、 fetch_values はエラーが発生する
    e = assert_raises(KeyError) { values.fetch_values(:foo, :bar, :invalid) }
    assert_equal 'key not found: :invalid', e.message

    # Hash#fetch と同様、fetch_values はブロックを使ってデフォルト値を返すことができる
    assert_equal [1, 2, :invalid], values.fetch_values(:foo, :bar, :invalid) {|k| k }
  end

  def test_positive_and_negative
    numbers = (-5..5)

    # positive? メソッドと negative? メソッドを使って、正または負の値を抜き出す
    assert_equal [1, 2, 3, 4, 5], numbers.select(&:positive?)
    assert_equal [-5, -4, -3, -2, -1], numbers.select(&:negative?)
  end

  def test_hash_operators
    # 右のハッシュは左のハッシュのサブセットである
    assert({ a: 1, b: 2 } > { a: 1 })

    # 右のハッシュは左のハッシュのサブセットではない（値が異なる）
    refute({ a: 1, b: 2 } > { a: 10 })

    # 右のハッシュは左のハッシュのサブセットではない（等しい）
    refute({ a: 1 } > { a: 1 })

    # 右のハッシュは左のハッシュのサブセット、もしくは両者が等しい
    assert({ a: 1 } >= { a: 1 })

    # 右のハッシュは左のハッシュのサブセットではない（別物）
    refute({ b: 1 } > { a: 1 })

    # 左のハッシュは右のハッシュのサブセットではない（別物）
    refute({ b: 1 } < { a: 1 })

    # 左のハッシュは右のハッシュのサブセットである
    assert({ a: 1, b: 2 } < { a: 1, b: 2, c: 3 })
  end

  def test_hash_to_proc
    hash = { a: 1, b: 2, c: 3 }
    keys = %i[a c d]

    # ハッシュをProcに変換できる
    assert_equal [1, 3, nil], keys.map(&hash)

    # 次のようにProc化したハッシュを個別に呼び出すこともできる
    hash_proc = hash.to_proc
    assert_equal 1, hash_proc.call(:a)
    assert_equal 2, hash_proc.call(:b)
    assert_equal nil, hash_proc.call(:d)

    # つまり &hash は下のようなコードと同等
    assert_equal [1, 3, nil], keys.map { |k| hash_proc.call(k) }

    # ハッシュをProc化しない場合は次のようなコードになる
    assert_equal [1, 3, nil], keys.map { |k| hash[k] }
  end

  require 'active_support/core_ext/object/try'
  User = Struct.new(:address)
  Address = Struct.new(:street)
  Street = Struct.new(:first_lane)
  def test_safe_navigation_operator
    street = Street.new('123')
    address = Address.new(street)
    user = User.new(address)
    # オブジェクトが存在する場合は普通にメソッドを呼び出せる
    assert_equal '123', user&.address&.street&.first_lane

    other = User.new
    # オブジェクトがnilでもNoMethodErrorが発生せずにnilが返る
    assert_nil other&.address&.street&.first_lane

    # Railsであれば try を使ったコードと同等
    assert_equal '123', user.try(:address).try(:street).try(:first_lane)
    assert_nil other.try(:address).try(:street).try(:first_lane)
  end
end