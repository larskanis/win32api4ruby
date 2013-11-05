# -*- coding: UTF-8 -*-

require 'ffi'

module Win32api4ruby
module AbstractMemoryExtensions
  ZeroZeroString = "\0\0"
  def to_s_utf16
    i = 0
    while self.get_bytes(i,2)!=ZeroZeroString
      i+=2
    end
    self.get_bytes(0,i)
  end

  if RUBY_VERSION<'1.9'
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
  else
    def to_s_utf8
      if Win32api4ruby::Base.unicode
        to_s_utf16.encode(Encoding::UTF_8, Encoding::UTF_16LE)
      else
        get_string(0).encode(Encoding::UTF_8, Encoding::Windows_1252)
      end
    end
  end
end

module StringExtensions
  if RUBY_VERSION<'1.9'
    # Converts a UTF-8 string to Windows-encoding based on the current
    # Win32api4ruby::Base.unicode setting.
    def to_s_win32
      if Win32api4ruby::Base.unicode
        @@iconv_Utf8ToUtf16 ||= Iconv.new('utf-16le', 'utf-8')
        @@iconv_Utf8ToUtf16.iconv(self) << AbstractMemoryExtensions::ZeroZeroString
      else
        @@iconv_Utf8ToAnsi ||= Iconv.new('windows-1252', 'utf-8')
        @@iconv_Utf8ToAnsi.iconv(self)
      end
    end
  else
    def to_s_win32
      if Win32api4ruby::Base.unicode
        self.encode(Encoding::UTF_16LE, Encoding::UTF_8) << AbstractMemoryExtensions::ZeroZeroString
      else
        self.encode(Encoding::Windows_1252, Encoding::UTF_8)
      end
    end
  end
end

class ::FFI::AbstractMemory
  include Win32api4ruby::AbstractMemoryExtensions
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
  def self.get_last_error_text(error_code=nil)
    message = FFI::MemoryPointer.new(1024) #store 1kb space
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
        FFI::MemoryPointer.from_string(data)
      when FFI::AbstractMemory
        data
      when NilClass
      else
        raise "#{data.class} instead of String or FFI::AbstractMemory"
    end

    data || FFI::MemoryPointer(size)
  end
end
end
