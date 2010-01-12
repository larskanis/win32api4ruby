require "test/unit"
require "win32api4ruby"

class TestWin32api4ruby < Test::Unit::TestCase
  include Win32api4ruby
  
  def test_global_lock
    Kernel.global_lock(123456)
  end

  def test_format_message
    message = DL.malloc(1024) #store 1kb space
    Kernel.format_message(0x1000, '', 100, 0, message, 1024, '')
    l = message.to_s.length
    assert l > 5
    assert l < 100
  end

  def test_get_set_last_error
    Kernel.set_last_error(100)
    assert_equal 100, Kernel.get_last_error
  end
end
