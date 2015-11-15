require_relative '../test/test_helper'

class WithoutPragmaTest < Minitest::Test
  def test_frozen_string
    # マジックコメント（Pragma）がないのでStringは freeze していない
    assert_equal "dlrow olleH", "Hello world".reverse!
    refute "Hello world".frozen?
  end
end
