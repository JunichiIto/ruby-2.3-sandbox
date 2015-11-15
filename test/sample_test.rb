require_relative '../test/test_helper'

class SampleTest < Minitest::Test
  def test_dig
    user = {
        user: {
            address: {
                street1: '123 Main street'
            }
        }
    }

    assert_equal '123 Main street', user.dig(:user, :address, :street1)

    results = [[[1, 2, 3]]]

    assert_equal 1, results.dig(0, 0, 0)

    assert_nil user.dig(:user, :adddresss, :street1)
    assert_nil user.dig(:user, :address, :street2)
  end

  def test_grep_v
    friends = %w[John Alain Jim Delmer]

    j_friends = friends.grep(/^J/)   # => ["John", "Jim"]
    assert_equal %w(John Jim), j_friends

    others    = friends.grep_v(/^J/) # => ["Alain", "Delmer"]
    assert_equal %w(Alain Delmer), others

    items = [1, 1.0, '1', nil]

    nums   = items.grep(Numeric)
    assert_equal [1, 1.0], nums

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

    assert_equal [1, 2], values.values_at(:foo, :bar)
    assert_equal [1, 2], values.fetch_values(:foo, :bar)

    assert_equal [1, 2, nil], values.values_at(:foo, :bar, :invalid)
    e = assert_raises(KeyError) { values.fetch_values(:foo, :bar, :invalid) }
    assert_equal 'key not found: :invalid', e.message
  end

  def test_positive?
    numbers = (-5..5)

    assert_equal [1, 2, 3, 4, 5], numbers.select(&:positive?)
    assert_equal [-5, -4, -3, -2, -1], numbers.select(&:negative?)
  end

  def test_hash_operators
    small     = { a: 1                }
    medium    = { a: 1, b: 2          }
    large     = { a: 1, b: 2, c: 3    }
    different = { totally: :different }

    assert({ a: 1, b: 2 } > { a: 1 })
    refute({ a: 1 } > { a: 1 })
    refute({ b: 1 } > { a: 1 })
    assert({ a: 1, b: 2 } < { a: 1, b: 2, c: 3 })
  end

  def test_hash_to_proc
    hash = { a: 1, b: 2, c: 3 }
    keys = %i[a c d]

    assert_equal [1, 3, nil], keys.map(&hash)
  end

  User = Struct.new(:address)
  Address = Struct.new(:street)
  Street = Struct.new(:first_lane)
  def test_safe_navigation_operator
    street = Street.new('123')
    address = Address.new(street)
    user = User.new(address)
    assert_equal '123', user&.address&.street&.first_lane

    other = User.new
    assert_nil other&.address&.street&.first_lane
  end

  def test_frozen_string
    assert_equal "dlrow olleH", "Hello world".reverse!
  end
end