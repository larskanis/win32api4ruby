require "test/unit"
require "win32api4ruby"
require File.join(File.dirname(__FILE__),"base")

module TestUser
  include Win32api4ruby

  def test_create_window_ex
    hwnd = User.create_window_ex(0, 'Button'.to_s_win32, "name".to_s_win32, User::WS_VISIBLE, 0,0,100,100, 0, 0, 0)
    assert hwnd > 0
    User.destroy_window(hwnd)
  end
end

define_test_class(TestUser)
