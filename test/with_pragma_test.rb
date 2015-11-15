# frozen_string_literal: true
require_relative '../test/test_helper'

class WithPragmaTest < Minitest::Test
  def test_frozen_string
    e = assert_raises(RuntimeError) { "Hello world".reverse! }
    assert_equal "can't modify frozen String", e.message
  end
end
