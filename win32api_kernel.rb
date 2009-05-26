if __FILE__ == $0
  require 'Win32API'
end

class Win32ApiKernel  < Win32ApiBase
  KERNEL32 = DL.dlopen('user32')
  
  #the functions that wrap the Win32API calls enforce type checking on arguments
  # (through #check). This is to be consistent with the Win32API which will assume
  # different arguments are calling different functions, throwing wacky errors
  #API WRAPPERS
  # --------------------------------------------------------------------------------------------------------------
  @@GlobalLock = Win32API.new('kernel32', 'GlobalLock', ['N'], 'N')
  def global_lock(hMovableMemory)
    check(hMovableMemory,Integer)
    exception_for_0{
      api_call(@@GlobalLock, hMovableMemory)
    }
  end
  # --------------------------------------------------------------------------------------------------------------
  @@GlobalFree = Win32API.new('kernel32', 'GlobalFree', ['N'], 'N')
  def global_free(hMovableMemory)
    check(hMovableMemory,Integer)
    exception_for_0{
      api_call(@@GlobalFree, hMovableMemory)
    }
  end
  # --------------------------------------------------------------------------------------------------------------
  @@GetLastError = Win32API.new('kernel32', 'GetLastError', [],  'N')
  def get_last_error()
      api_call(@@GetLastError)
  end
  # --------------------------------------------------------------------------------------------------------------
  @@FormatMessage = Win32API.new('kernel32', 'FormatMessage', ['N','P','N','N','P','N','P'], 'N')
  def format_message(dwFlags, lpSource, dwMessageID, dwLanguageID, lpBuffer, nSize, arguments)
    check(dwFlags,Integer);
    check(lpSource,String);
    check(dwMessageID,Integer)
    check(dwLanguageID,Integer); check(lpBuffer,String);
    check(nSize,Integer);
    check(arguments,String)
    exception_for_0{
      api_call(@@FormatMessage, dwFlags, lpSource, dwMessageID, dwLanguageID, lpBuffer, nSize, arguments)
    }
  end
end

if __FILE__ == $0
end
