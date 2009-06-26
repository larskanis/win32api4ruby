require "dl"
require 'Win32API'


class Win32ApiBase
  @@GetLastError = Win32API.new('kernel32', 'GetLastError', [],  'N')
  @@SetLastError = Win32API.new('kernel32', 'SetLastError', ['N'],  'N')
  @@FormatMessage = Win32API.new('kernel32', 'FormatMessage', ['N','P','N','N','P','N','P'], 'N')
  class DevmodStructur
    def self.struct_def
      # ---------------------------------------------------------------------------
      # die Basistypen
        #~ C : char
        #~ c : char *
        #~ H : short
        #~ h : short *
        #~ I : int
        #~ i : int *
        #~ L : long
        #~ l : long *
        #~ F : float
        #~ f : float *
        #~ D : double
        #~ d : double *
        #~ S : const char *
        #~ s : char *
        #~ A : const type[]
        #~ a : type[] (allocates new memory space)
        #~ P : void * (same as 'p')
        #~ p : void * (same as 'P')
        #~ 0 : void function (this must be a first character of the prototype)
        
        # short = 2 Byte
        # int = 2 Byte
        # word = 2 Byte
        # long = 4 Byte
        # dword = 4 Byte
        # lpstr = Long-Zeiger 
        
      string = "S"
      char = "C"
      short = "H"
      word = "H"
      dword = "L"
      # ---------------------------------------------------------------------------
      # der Definitionsstring für die Struktur
        string +              #~ TCHAR dmDeviceName[CCHDEVICENAME];
        word +              #~ WORD  dmSpecVersion;
        word +              #~ WORD  dmDriverVersion;
        word +              #~ WORD  dmSize;
        word +              #~ WORD  dmDriverExtra;
        dword +             #~ DWORD dmFields;
        #~ union {
          #~ struct {
            short +         #~ short dmOrientation;
            short +         #~ short dmPaperSize;
            short +         #~ short dmPaperLength;
            short +         #~ short dmPaperWidth;
            short +         #~ short dmScale;
            short +         #~ short dmCopies;
            short +         #~ short dmDefaultSource;
            short +         #~ short dmPrintQuality;
          #~ } ;
          #~ struct {
            # nur für Displays
            #~ pointl +        #~ POINTL dmPosition;
            #~ dword +         #~ DWORD dmDisplayOrientation;
            #~ dword +         #~ DWORD dmDisplayFixedOutput;
          #~ } ;
        #~ } ;
        short +             #~ short dmColor;
        short +             #~ short dmDuplex;
        short +             #~ short dmYResolution;
        short +             #~ short dmTTOption;
        short +             #~ short dmCollate;
        char +              #~ TCHAR dmFormName[CCHFORMNAME];
        word +              #~ WORD  dmLogPixels;
        dword +             #~ DWORD dmBitsPerPel;
        dword +             #~ DWORD dmPelsWidth;
        dword +             #~ DWORD dmPelsHeight;
        #~ union {
            # nur für Displays
#          dword +           #~ DWORD dmDisplayFlags;
          dword +           #~ DWORD dmNup;
        #~ } ;
        dword +             #~ DWORD dmDisplayFrequency;
      #~ #if (WINVER >= 0x0400)
        dword +             #~ DWORD dmICMMethod;
        dword +             #~ DWORD dmICMIntent;
        dword +             #~ DWORD dmMediaType;
        dword +             #~ DWORD dmDitherType;
        dword +             #~ DWORD dmReserved1;
        dword +             #~ DWORD dmReserved2;
      #~ #if (WINVER >= 0x0500) || (_WIN32_WINNT >= 0x0400)
        dword +             #~ DWORD dmPanningWidth;
        dword               #~ DWORD dmPanningHeight;
      #~ #endif 
      #~ #endif 
      #~ } DEVMODE, *PDEVMODE, *LPDEVMODE;
    end
    
    
    def initialize(mem)
      @dm_struct = mem
    end
    
    def get_struct
      # ---------------------------------------------------------------------------
      # die Struktur
      @dm_struct.struct!(DevmodStructur.struct_def,
        #~ typedef struct _devicemode {
          :dmDeviceName,
          :dmSpecVersion,
          :dmDriverVersion,
          :dmSize,
          :dmDriverExtra,
          :dmFields,
          #~ union {
            #~ struct {
              :dmOrientation,
              :dmPaperSize,
              :dmPaperLength,
              :dmPaperWidth,
              :dmScale,
              :dmCopies,
              :dmDefaultSource,
              :dmPrintQuality,
            #~ } ,
            #~ struct {
            # nur für Displays
              #~ :dmPosition,
              #~ :dmDisplayOrientation,
              #~ :dmDisplayFixedOutput,
            #~ } ,
          #~ } ,
          :dmColor,
          :dmDuplex,
          :dmYResolution,
          :dmTTOption,
          :dmCollate,
          :dmFormName,
          :dmLogPixels,
          :dmBitsPerPel,
          :dmPelsWidth,
          :dmPelsHeight,
          #~ union {
            # nur für Displays
            #~ :dmDisplayFlags,
            :dmNup,
          #~ } ,
          :dmDisplayFrequency,
        #~ #if (WINVER >= 0x0400)
          :dmICMMethod,
          :dmICMIntent,
          :dmMediaType,
          :dmDitherType,
          :dmReserved1,
          :dmReserved2,
        #~ #if (WINVER >= 0x0500) || (_WIN32_WINNT >= 0x0400)
          :dmPanningWidth,
          :dmPanningHeight
        #~ #endif 
        #~ #endif 
        #~ } DEVMODE, *PDEVMODE, *LPDEVMODE;
      )
      @dm_struct
      
      # ---------------------------------------------------------------------------
      # Original-Definition aus dem MSN
      #~ typedef struct _devicemode {
        #~ TCHAR dmDeviceName[CCHDEVICENAME];
        #~ WORD  dmSpecVersion;
        #~ WORD  dmDriverVersion;
        #~ WORD  dmSize;
        #~ WORD  dmDriverExtra;
        #~ DWORD dmFields;
        #~ union {
          #~ struct {
            #~ short dmOrientation;
            #~ short dmPaperSize;
            #~ short dmPaperLength;
            #~ short dmPaperWidth;
            #~ short dmScale;
            #~ short dmCopies;
            #~ short dmDefaultSource;
            #~ short dmPrintQuality;
          #~ } ;
          #~ struct {
            #~ POINTL dmPosition;
            #~ DWORD dmDisplayOrientation;
            #~ DWORD dmDisplayFixedOutput;
          #~ } ;
        #~ } ;
        #~ short dmColor;
        #~ short dmDuplex;
        #~ short dmYResolution;
        #~ short dmTTOption;
        #~ short dmCollate;
        #~ TCHAR dmFormName[CCHFORMNAME];
        #~ WORD  dmLogPixels;
        #~ DWORD dmBitsPerPel;
        #~ DWORD dmPelsWidth;
        #~ DWORD dmPelsHeight;
        #~ union {
          #~ DWORD dmDisplayFlags;
          #~ DWORD dmNup;
        #~ } ;
        #~ DWORD dmDisplayFrequency;
      #~ #if (WINVER >= 0x0400)
        #~ DWORD dmICMMethod;
        #~ DWORD dmICMIntent;
        #~ DWORD dmMediaType;
        #~ DWORD dmDitherType;
        #~ DWORD dmReserved1;
        #~ DWORD dmReserved2;
      #~ #if (WINVER >= 0x0500) || (_WIN32_WINNT >= 0x0400)
        #~ DWORD dmPanningWidth;
        #~ DWORD dmPanningHeight;
      #~ #endif 
      #~ #endif 
      #~ } DEVMODE, *PDEVMODE, *LPDEVMODE;
    end
    
  end
  # ==============================================================================================================
  
  class ApiError < RuntimeError
  end
  # ==============================================================================================================
  
  def exception_for_0()
    delete_errors
    res = yield
    if res == 0
      raise ApiError, get_last_error_text
    end
    return res
  end
  
  def exception_for_nil()
    delete_errors
    res = yield
    if res.nil?
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