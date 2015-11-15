# frozen_string_literal: true
require_relative '../test/test_helper'

class PragmaEnabledTest < Minitest::Test
  def test_frozen_string
    e = assert_raises(RuntimeError) { "Hello world".reverse! }
    # マジックコメント（Pragma）がtrueなのでStringは freeze している
    assert_equal "can't modify frozen String", e.message
    assert "Hello world".frozen?
  end
end
