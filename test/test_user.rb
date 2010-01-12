require "test/unit"
require "win32api4ruby"

class TestWin32api4ruby < Test::Unit::TestCase
  include Win32api4ruby

  def test_create_window_ex
    hwnd = User.create_window_ex(0, 'Button', name, User::WS_VISIBLE, 0,0,100,100, 0, 0, 0, 0)
    assert hwnd > 0
    User.destroy_window(hwnd)
  end
end



