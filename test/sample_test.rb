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
end