# -*- coding: UTF-8 -*-

require "dl"
require 'Win32API'


class Win32ApiBase
  @@GetLastError = Win32API.new('kernel32', 'GetLastError', [],  'N')
  @@SetLastError = Win32API.new('kernel32', 'SetLastError', ['N'],  'N')
  @@FormatMessage = Win32API.new('kernel32', 'FormatMessage', ['N','P','N','N','P','N','P'], 'N')
    
  # ==============================================================================================================
  
  class ApiError < RuntimeError
  end
  # ==============================================================================================================
  
  def exception_for_0
    delete_errors
    res = yield
    if res == 0
      raise ApiError, get_last_error_text
    end
    return res
  end
  
  def exception_for_com_error
    delete_errors
    res = yield
    if res != 0
      text = case
        when (res&0xffff0000) == 0x80070000 then `net helpmsg #{res&0xffff}`.strip
        else get_last_error_text
      end
      raise ApiError, sprintf('%#x %s', res, text)
    end
    return res
  end
  
  def exception_for_nil
    delete_errors
    res = yield
    if res.nil?
      raise ApiError, get_last_error_text
    end
    return res
  end

  def exception_for_negative
    delete_errors
    res = yield
    if res < 0
      raise ApiError, get_last_error_text
    end
    return res
  end


  # --------------------------------------------------------------------------------------------------------------
  
  def format_message(dwFlags, lpSource, dwMessageID, dwLanguageID, lpBuffer, nSize, arguments)
    check(dwFlags,Integer);
    check(lpSource,String);
    check(dwMessageID,Integer)
    check(dwLanguageID,Integer); check(lpBuffer,String);
    check(nSize,Integer);
    check(arguments,String)
    api_call(@@FormatMessage, dwFlags, lpSource, dwMessageID, dwLanguageID, lpBuffer, nSize, arguments)
  end
  # --------------------------------------------------------------------------------------------------------------
  def pointer_to_s(ptr)
    if ptr != 0
      ptr1 = DL::PtrData.new(ptr)
      ptr1.to_s
    end
  end
  # --------------------------------------------------------------------------------------------------------------
  def pointer_to_devmode(ptr)
    #~ if ptr != 0
      #~ ptr1 = DL::PtrData.new(ptr)
      #~ ptr1
    #~ end
  end
  # --------------------------------------------------------------------------------------------------------------
  def get_last_error_text
    message = " " * 1024 #store 1kb space
    format_message(0x1000, '', get_last_error(), 0, message, 1024, '')
    message[0 ... message.index("\0")]
  end
  # --------------------------------------------------------------------------------------------------------------
  def show_error
    puts get_last_error_text
  end
  # --------------------------------------------------------------------------------------------------------------
  def api_call(apiFunction, *args)
    begin
      res = apiFunction.call(*args)
      #~ p "res #{res.inspect}"
      erg = res.kind_of?(Array) ? res[0] : res
      return erg
    rescue RuntimeError => e
      raise "#{e.class} #{e}: #{show_error}"
    end
  end
#    private :api_call
  # --------------------------------------------------------------------------------------------------------------
  def check(variable, klass)
    raise "#{variable}, #{variable.class} != #{klass.to_s}" unless variable.kind_of?(klass)
  end
  private :check
  # --------------------------------------------------------------------------------------------------------------
  def with_global_lock(handle)
    begin
      globalMemory = global_lock(handle)
      yield globalMemory
    ensure
      show_error unless global_free(handle) == 0
    end
  end
  # --------------------------------------------------------------------------------------------------------------
  def delete_errors
      #~ void WINAPI SetLastError(
        #~ __in  DWORD dwErrCode
      #~ );
    api_call(@@SetLastError, 0)
  end
  # --------------------------------------------------------------------------------------------------------------
  def get_last_error()
    api_call(@@GetLastError)
  end
end

if __FILE__ == $0

  dms = Win32ApiBase::DevmodStructur.new
end