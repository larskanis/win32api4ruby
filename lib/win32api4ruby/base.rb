# -*- coding: UTF-8 -*-

require "dl"

module Win32api4ruby
class Base
  
  class ApiError < RuntimeError
  end

  
  def self.exception_for_0
    delete_errors
    res = yield
    if res == 0
      raise ApiError, get_last_error_text
    end
    return res
  end

  def self.exception_for_non_0
    delete_errors
    res = yield
    if res != 0
      raise ApiError, get_last_error_text
    end
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
    if res.nil?
      raise ApiError, get_last_error_text
    end
    return res
  end

  def self.exception_for_negative
    delete_errors
    res = yield
    if res < 0
      raise ApiError, get_last_error_text
    end
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
  def self.get_last_error_text
    message = DL.malloc(1024) #store 1kb space
    Kernel.format_message(0x1000, '', Kernel.get_last_error(), 0, message, 1024, '')
    message.to_s
  end
  # --------------------------------------------------------------------------------------------------------------
  def self.show_error
    puts get_last_error_text
  end
  # --------------------------------------------------------------------------------------------------------------
  def self.api_call(apiFunction, *args)
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
  def self.check(variable, klass)
    raise "#{variable}, #{variable.class} != #{klass.to_s}" unless variable.kind_of?(klass)
  end
  # --------------------------------------------------------------------------------------------------------------
  def self.delete_errors
    Kernel.set_last_error(0)
  end
end
end
