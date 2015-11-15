# frozen_string_literal: false
require_relative '../test/test_helper'

class PragmaDisabledTest < Minitest::Test
  def test_frozen_string
    # マジックコメント（Pragma）がfalseなのでStringは freeze していない
    assert_equal "dlrow olleH", "Hello world".reverse!
    refute "Hello world".frozen?
  end
end
