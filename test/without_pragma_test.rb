# frozen_string_literal: false
require_relative '../test/test_helper'

class WithoutPragmaTest < Minitest::Test
  def test_frozen_string
    assert_equal "dlrow olleH", "Hello world".reverse!
  end
end
