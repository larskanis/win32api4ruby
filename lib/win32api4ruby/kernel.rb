# -*- coding: UTF-8 -*-

require 'win32api4ruby/base'

module Win32api4ruby
class Kernel  < Base
  KERNEL32 = DL.dlopen('kernel32')

  #the functions that wrap the Win32API calls enforce type checking on arguments
  # (through #check). This is to be consistent with the Win32API which will assume
  # different arguments are calling different functions, throwing wacky errors
  #API WRAPPERS
  # --------------------------------------------------------------------------------------------------------------
  GlobalLock = KERNEL32['GlobalLock', 'LL']
  def self.global_lock(hMovableMemory)
    check(hMovableMemory,Integer)
    exception_for_0{
      api_call(GlobalLock, hMovableMemory)
    }
  end
  GlobalUnlock = KERNEL32['GlobalUnlock', 'LL']
  def self.global_unlock(hMovableMemory)
    check(hMovableMemory,Integer)
    api_call(GlobalUnlock, hMovableMemory)
  end
  # --------------------------------------------------------------------------------------------------------------
  GlobalFree = KERNEL32['GlobalFree', 'LL']
  def self.global_free(hMovableMemory)
    check(hMovableMemory,Integer)
    exception_for_non_0{
      api_call(GlobalFree, hMovableMemory)
    }
  end
  # --------------------------------------------------------------------------------------------------------------
  GetLastError = KERNEL32['GetLastError', 'L']
  def self.get_last_error()
      api_call(GetLastError)
  end
  # --------------------------------------------------------------------------------------------------------------
  SetLastError = KERNEL32['SetLastError', 'LL']
  def self.set_last_error(v)
    check(v, Integer)
    api_call(SetLastError, v)
  end
  # --------------------------------------------------------------------------------------------------------------
  FormatMessageW = KERNEL32['FormatMessageW', 'LLPLLpLP']
  FormatMessageA = KERNEL32['FormatMessageA', 'LLPLLpLP']
  def self.format_message(dwFlags, lpSource, dwMessageID, dwLanguageID, lpBuffer, nSize, arguments)
    check(dwFlags,Integer);
    check(lpSource,String);
    check(dwMessageID,Integer)
    check(dwLanguageID,Integer); check(lpBuffer,DL::PtrData);
    check(nSize,Integer);
    check(arguments,String)
    api_call(unicode ? FormatMessageW : FormatMessageA, dwFlags, lpSource, dwMessageID, dwLanguageID, lpBuffer, nSize, arguments)
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
