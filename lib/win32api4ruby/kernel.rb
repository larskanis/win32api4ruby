# -*- coding: UTF-8 -*-

require 'win32api4ruby/base'

module Win32api4ruby
class Kernel  < Base
  extend FFI::Library
  ffi_lib 'kernel32'
  ffi_convention :stdcall

  #the functions that wrap the Win32API calls enforce type checking on arguments
  # (through #check). This is to be consistent with the Win32API which will assume
  # different arguments are calling different functions, throwing wacky errors
  #API WRAPPERS
  attach_function :GlobalLock, [ :long ], :long
  def self.global_lock(hMovableMemory)
    check(hMovableMemory,Integer)
    exception_for_0{
      GlobalLock(hMovableMemory)
    }
  end

  attach_function :GlobalUnlock, [ :long ], :long
  def self.global_unlock(hMovableMemory)
    check(hMovableMemory,Integer)
    GlobalUnlock(hMovableMemory)
  end

  attach_function :GlobalFree, [ :long ], :long
  def self.global_free(hMovableMemory)
    check(hMovableMemory,Integer)
    exception_for_non_0{
      GlobalFree(hMovableMemory)
    }
  end

  attach_function :GetLastError, [], :long
  def self.get_last_error()
    GetLastError()
  end

  attach_function :SetLastError, [:long], :long
  def self.set_last_error(v)
    check(v, Integer)
    SetLastError(v)
  end

  attach_function :FormatMessageW, [:long, :pointer, :long, :long, :pointer, :long, :pointer], :long
  attach_function :FormatMessageA, [:long, :pointer, :long, :long, :pointer, :long, :pointer], :long
  def self.format_message(dwFlags, lpSource, dwMessageID, dwLanguageID, lpBuffer, nSize, arguments)
    check(dwFlags,Integer);
    check(lpSource,String);
    check(dwMessageID,Integer)
    check(dwLanguageID,Integer); check(lpBuffer,FFI::AbstractMemory);
    check(nSize,Integer);
    check(arguments,String)
    args = dwFlags, lpSource, dwMessageID, dwLanguageID, lpBuffer, nSize, arguments
    unicode ? FormatMessageW(*args) : FormatMessageA(*args)
  end
  # --------------------------------------------------------------------------------------------------------------
  def self.with_global_lock(handle)
    begin
      globalMemory = global_lock(handle)
      yield globalMemory
    ensure
      global_free(handle)
    end
  end
end
end
