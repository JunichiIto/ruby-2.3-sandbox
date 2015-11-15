# frozen_string_literal: true
require_relative '../test/test_helper'

class PragmaEnabledTest < Minitest::Test
  def test_frozen_string
    # マジックコメント（Pragma）がtrueなのでStringは freeze している
    e = assert_raises(RuntimeError) { "Hello world".reverse! }
    assert_equal "can't modify frozen String", e.message
    assert "Hello world".frozen?
  end
end
