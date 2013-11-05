require "test/unit"
require "win32api4ruby"
require "ffi"
require File.join(File.dirname(__FILE__),"base")

module TestKernel
  include Win32api4ruby
  
  def test_global_lock
    assert_raise(Win32api4ruby::Base::ApiError){
      Kernel.global_lock(1234567)
    }
  end

  def test_format_message
    message = FFI::MemoryPointer.new(1024) #store 1kb space
    Kernel.format_message(0x1000, '', 100, 0, message, 1024, '')
    mu = message.to_s_utf8
    assert mu.length > 5
    assert mu.length < 100
    if String.method_defined?(:encoding)
      assert mu.valid_encoding?
      assert_equal Encoding::UTF_8, mu.encoding
    end
  end

  def test_get_set_last_error
    Kernel.set_last_error(100)
    assert_equal 100, Kernel.get_last_error
  end
end

define_test_class(TestKernel)
