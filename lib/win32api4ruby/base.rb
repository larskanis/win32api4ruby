# -*- coding: UTF-8 -*-

require "dl"
require 'iconv'

module Win32api4ruby
module DL_PtrDataExtensions
  ZeroZeroString = "\0\0"
  def to_s_utf16
    i = 0
    while self[i,2]!=ZeroZeroString
      i+=2
    end
    self[0,i]
  end
  
  # Converts the Data containing a Unicode or Ansi-Text based on the current
  # Win32api4ruby::Base.unicode setting to UTF-8.
  def to_s_utf8
    if Win32api4ruby::Base.unicode
      @@iconv_Utf16ToUtf8 ||= Iconv.new('utf-8', 'utf-16le')
      @@iconv_Utf16ToUtf8.iconv to_s_utf16
    else
      @@iconv_AnsiToUtf8 ||= Iconv.new('utf-8', 'windows-1252')
      @@iconv_AnsiToUtf8.iconv to_s
    end
  end
end

module StringExtensions
  # Converts a UTF-8 string to Windows-encoding based on the current
  # Win32api4ruby::Base.unicode setting.
  def to_s_win32
    if Win32api4ruby::Base.unicode
      @@iconv_Utf8ToUtf16 ||= Iconv.new('utf-16le', 'utf-8')
      @@iconv_Utf8ToUtf16.iconv(self) << DL_PtrDataExtensions::ZeroZeroString
    else
      @@iconv_Utf8ToAnsi ||= Iconv.new('windows-1252', 'utf-8')
      @@iconv_Utf8ToAnsi.iconv(self)
    end
  end
end

class ::DL::PtrData
  include Win32api4ruby::DL_PtrDataExtensions
end

class ::String
  include Win32api4ruby::StringExtensions
end

class Base
  
  class ApiError < RuntimeError
    def initialize(code, text)
      super(text)
      @code = code
    end
  end
  
  # use ansi-methods by default
  @@unicode = false
  
  def self.unicode=(enabled)
    @@unicode = !!enabled
  end

  def self.unicode
    @@unicode
  end
  
  def self.exception_for_0
    delete_errors
    res = yield
    raise_last_error if res == 0
    return res
  end

  def self.exception_for_non_0
    delete_errors
    res = yield
    raise_last_error if res != 0
    return res
  end

  def self.exception_for_com_error
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
  
  def self.exception_for_nil
    delete_errors
    res = yield
    raise_last_error if res.nil?
    return res
  end

  def self.exception_for_negative
    delete_errors
    res = yield
    raise_last_error if res < 0
    return res
  end

  # --------------------------------------------------------------------------------------------------------------
  def self.pointer_to_s(ptr)
    if ptr != 0
      ptr1 = DL::PtrData.new(ptr)
      ptr1.to_s
    end
  end
  # --------------------------------------------------------------------------------------------------------------
  def self.get_last_error_text(error_code=nil)
    message = DL.malloc(1024) #store 1kb space
    error_code ||= Kernel.get_last_error()
    Kernel.format_message(0x1000, '', error_code, 0, message, message.size, '')
    message = unicode ? message.to_s_utf8 : message.to_s
    sprintf('%s (%d)', message.chomp, error_code)
  end
  def self.raise_last_error
    code = Kernel.get_last_error()
    raise ApiError.new(code, get_last_error_text(code))
  end
  # --------------------------------------------------------------------------------------------------------------
  def self.show_error
    puts get_last_error_text
  end
  # --------------------------------------------------------------------------------------------------------------
  def self.api_call(apiFunction, *args)
    begin
      res = apiFunction.call(*args)
      erg = res.kind_of?(Array) ? res[0] : res
      return erg
    rescue RuntimeError => e
      raise "#{e.class} #{e}: #{show_error}"
    end
  end
#    private :api_call
  # --------------------------------------------------------------------------------------------------------------
  def self.check(variable, klass)
    raise "#{variable}, #{variable.class} != #{klass.to_s}" unless variable.kind_of?(klass)
  end
  # --------------------------------------------------------------------------------------------------------------
  def self.delete_errors
    Kernel.set_last_error(0)
  end

  def self.prepare_PtrData(data=nil, size=nil)
    raise "neither data nor size given" unless data || size
    
    data = case data
      when String
        dlinitdata = DL.malloc(data.length)
        dlinitdata[0, dlinitdata.size] = data
        dlinitdata
      when DL::PtrData
        data
      when NilClass
      else
        raise "#{data.class} instead of String or DL::PtrData"
    end
      
    data || DL.malloc(size)
  end
end
end
