# -*- coding: UTF-8 -*-

require 'win32api4ruby/base'

module Win32api4ruby
class Comdlg < Base
  extend FFI::Library
  ffi_lib 'comdlg32'
  ffi_convention :stdcall

  ##
  ##  Flags for PrintDlg and PrintDlgEx.
  ##
  PD_ALLPAGES = 0x00000000
  PD_SELECTION = 0x00000001
  PD_PAGENUMS = 0x00000002
  PD_NOSELECTION = 0x00000004
  PD_NOPAGENUMS = 0x00000008
  PD_COLLATE = 0x00000010
  PD_PRINTTOFILE = 0x00000020
  PD_PRINTSETUP = 0x00000040
  PD_NOWARNING = 0x00000080
  PD_RETURNDC = 0x00000100
  PD_RETURNIC = 0x00000200
  PD_RETURNDEFAULT = 0x00000400
  PD_SHOWHELP = 0x00000800
  PD_ENABLEPRINTHOOK = 0x00001000
  PD_ENABLESETUPHOOK = 0x00002000
  PD_ENABLEPRINTTEMPLATE = 0x00004000
  PD_ENABLESETUPTEMPLATE = 0x00008000
  PD_ENABLEPRINTTEMPLATEHANDLE = 0x00010000
  PD_ENABLESETUPTEMPLATEHANDLE = 0x00020000
  PD_USEDEVMODECOPIES = 0x00040000
  PD_USEDEVMODECOPIESANDCOLLATE = 0x00040000
  PD_DISABLEPRINTTOFILE = 0x00080000
  PD_HIDEPRINTTOFILE = 0x00100000
  PD_NONETWORKBUTTON = 0x00200000


  #the functions that wrap the Win32API calls enforce type checking on arguments
  # (through #check). This is to be consistent with the Win32API which will assume
  # different arguments are calling different functions, throwing wacky errors
  #API WRAPPERS
  # --------------------------------------------------------------------------------------------------------------
  attach_function :PrintDlgW, [ :pointer ], :long
  attach_function :PrintDlgA, [ :pointer ], :long
  def self.print_dlg(pPrintDlg)
    check(pPrintDlg, FFI::AbstractMemory)
    exception_for_0{
      unicode ? PrintDlgW(pPrintDlg) : PrintDlgA(pPrintDlg)
    }
  end

  attach_function :PrintDlgExW, [ :pointer ], :long
  attach_function :PrintDlgExA, [ :pointer ], :long
  def self.print_dlg_ex(pPrintDlgEx)
    exception_for_com_error{
      unicode ? PrintDlgExW(pPrintDlgEx) : PrintDlgExA(pPrintDlgEx)
    }
  end

  attach_function :PageSetupDlgW, [ :pointer ], :int
  attach_function :PageSetupDlgA, [ :pointer ], :int
  def self.print_setup_dlg(pPageSetupDlg)
    exception_for_0{
      unicode ? PageSetupDlgW(pPageSetupDlg) : PageSetupDlgA(pPageSetupDlg)
    }
  end

  class PRINTDLG < FFI::Struct
    layout :lStructSize, :uint32,
        :hwndOwner, :uint32,
        :hDevMode, :uint32,
        :hDevNames, :uint32,
        :hDC, :uint32,
        :Flags, :uint32,
        :nFromPage, :uint16,
        :nToPage, :uint16,
        :nMinPage, :uint16,
        :nMaxPage, :uint16,
        :nCopies, :uint16,
        :hInstance, :uint32,
        :lCustData, :pointer,
        :lpfnPrintHook, :pointer,
        :lpfnSetupHook, :pointer,
        :lpPrintTemplateName, :pointer,
        :lpSetupTemplateName, :pointer,
        :hPrintTemplate, :uint32,
        :hSetupTemplate, :uint32
  end

  def self.create_PRINTDLG(ptrdata=nil, size=nil)
    data = PRINTDLG.new(ptrdata || (size && FFI::MemoryPointer.new(size)))
    data[:lStructSize] = 66
    return data
  end

  class PAGESETUPDLG < FFI::Struct
    layout  :lStructSize, :uint32,
      :hwndOwner, :uint32,
      :hDevMode, :uint32,
      :hDevNames, :uint32,
      :Flags, :uint32,

      :ptPaperSizeX, :long,
      :ptPaperSizeY, :long,

      :rtMinMarginL, :long,
      :rtMinMarginT, :long,
      :rtMinMarginR, :long,
      :rtMinMarginB, :long,

      :rtMarginL, :long,
      :rtMarginT, :long,
      :rtMarginR, :long,
      :rtMarginB, :long,

      :hInstance, :uint32,
      :lCustData, :pointer,
      :lpfnPageSetupHook, :pointer,
      :lpfnPagePaintHook, :pointer,
      :lpPageSetupTemplateName, :pointer,
      :hPageSetupTemplate, :uint32
  end

  def self.create_PAGESETUPDLG(ptrdata=nil, size=nil)
    data = PAGESETUPDLG.new(ptrdata || (size && FFI::MemoryPointer.new(size)))
    data[:lStructSize] = PAGESETUPDLG.size
    return data
  end

  class PRINTDLGEX < FFI::Struct
    layout :lStructSize, :uint32,
      :hwndOwner, :uint32,
      :hDevMode, :uint32,
      :hDevNames, :uint32,
      :hDC, :uint32,
      :Flags, :uint32,
      :Flags2, :uint32,
      :ExclusionFlags, :uint32,
      :nPageRanges, :uint32,
      :nMaxPageRanges, :uint32,
      :lpPageRanges, :pointer,
      :nMinPage, :uint32,
      :nMaxPage, :uint32,
      :nCopies, :uint32,
      :hInstance, :uint32,
      :lpPrintTemplateName, :pointer,
      :lpCallback, :pointer,
      :nPropertyPages, :uint32,
      :plphPropertyPages, :pointer,
      :nStartPage, :uint32,
      :dwResultAction, :uint32
  end
  def self.create_PRINTDLGEX(ptrdata=nil, size=nil)
    data = PRINTDLGEX.new(ptrdata || (size && FFI::MemoryPointer.new(size)))
    data[:lStructSize] = PRINTDLGEX.size
    return data
  end

  class DEVNAMES < FFI::Struct
    # struct tagDEVNAMES {
    #   WORD wDriverOffset;
    #   WORD wDeviceOffset;
    #   WORD wOutputOffset;
    #   WORD wDefault;
    # } DEVNAMES
    layout :wDriverOffset, :uint16,
        :wDeviceOffset, :uint16,
        :wOutputOffset, :uint16,
        :wDefault, :uint16
  end
  def self.create_DEVNAMES(ptrdata=nil, size=nil)
    DEVNAMES.new(ptrdata || (size && FFI::MemoryPointer.new(size)))
  end


end
end
