require "test/unit"
require "win32api4ruby"

class TestWin32api4ruby < Test::Unit::TestCase
  include Win32api4ruby
  
  def test_global_lock
    assert_raise(Win32api4ruby::Base::ApiError){
      Kernel.global_lock(1234567)
    }
  end

  def test_format_message
    message = DL.malloc(1024) #store 1kb space
    Kernel.format_message(0x1000, '', 100, 0, message, 1024, '')
    l = message.to_s_utf8.length
    assert l > 5
    assert l < 100
  end

  def test_get_set_last_error
    Kernel.set_last_error(100)
    assert_equal 100, Kernel.get_last_error
  end
end

Win32api4ruby::Base.unicode = false
Test::Unit::AutoRunner.run
Win32api4ruby::Base.unicode = true
Test::Unit::AutoRunner.run
