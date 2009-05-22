class Win32ApiBase
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
  def show_error
    message = " " * 1024 #store 1kb space
    format_message(0x1000, '', get_last_error(), 0, message, 1024, '')
    puts message[0 ... message.index("\0")]
  end
  # --------------------------------------------------------------------------------------------------------------
  def api_call(apiFunction, *args)
    begin
      res = apiFunction.call(*args)
      return res.kind_of?(Array) ? res[0] : res
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
end