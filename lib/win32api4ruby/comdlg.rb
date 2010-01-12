# -*- coding: UTF-8 -*-

require 'win32api4ruby/base'

module Win32api4ruby
class Comdlg < Base
  COMDLG32 = DL.dlopen('comdlg32')
  
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
  PrintDlg = COMDLG32['PrintDlg', 'Lp']
  def self.print_dlg(pPrintDlg)
    check(pPrintDlg, DL::PtrData)
    exception_for_0{
      api_call(PrintDlg, pPrintDlg)
    }
  end

  PrintDlgEx = COMDLG32['PrintDlgEx', 'Lp']
  def self.print_dlg_ex(pPrintDlgEx)
    exception_for_com_error{
      api_call(PrintDlgEx, pPrintDlgEx)
    }
  end
  
  PageSetupDlg = COMDLG32['PageSetupDlg', 'Ip']
  def self.print_setup_dlg(pPageSetupDlg)
    exception_for_0{
      api_call(PageSetupDlg, pPageSetupDlg)
    }
  end

  PRINTDLG_types = "L"*2 + "L"*2 + "L"*2 + "H"*5 + "L"*8
  def self.create_PRINTDLG
    pdlg = DL.malloc(DL.sizeof(PRINTDLG_types))
    pdlg.struct!(PRINTDLG_types, 
        :lStructSize,
        :hwndOwner,
        :hDevMode,
        :hDevNames,
        :hDC,
        :Flags,
        :nFromPage,
        :nToPage,
        :nMinPage,
        :nMaxPage,
        :nCopies,
        :hInstance,
        :lCustData,
        :lpfnPrintHook,
        :lpfnSetupHook,
        :lpPrintTemplateName,
        :lpSetupTemplateName,
        :hPrintTemplate,
        :hSetupTemplate)
    #~ pdlg[:lStructSize] = DL.sizeof(PRINTDLG_types)
    pdlg[:lStructSize] = 66
    return pdlg
  end

  PAGESETUPDLG_types = "L"*2 + "l"*2 + "L" + "L"*2 + "L"*4*2 + "L"*4 + "p" + "L"
  def self.create_PAGESETUPDLG
    pdlg = DL.malloc(DL.sizeof(PAGESETUPDLG_types))
    pdlg.struct!(PAGESETUPDLG_types, 
      :lStructSize,
      :hwndOwner,
      :hDevMode,
      :hDevNames,
      :Flags,
      :ptPaperSizeX, :ptPaperSizeY,
      :rtMinMarginL,:rtMinMarginT,:rtMinMarginR,:rtMinMarginB,
      :rtMarginL,:rtMarginT,:rtMarginR,:rtMarginB,
      :hInstance,
      :lCustData,
      :lpfnPageSetupHook,
      :lpfnPagePaintHook,
      :lpPageSetupTemplateName,
      :hPageSetupTemplate
    )
    pdlg[:lStructSize] = DL.sizeof(PAGESETUPDLG_types)
    return pdlg
  end
  
  PRINTDLGEX_types = "L"*5 + "L"*5 + "P" + "L"*3 + "L" + "S" + "P" + "L" + "P" +"L"*2
  def self.create_PRINTDLGEX
    pdlg = DL.malloc(DL.sizeof(PRINTDLGEX_types))
    pdlg.struct!(PRINTDLGEX_types, 
      :lStructSize,
      :hwndOwner,
      :hDevMode,
      :hDevNames,
      :hDC,
      :Flags,
      :Flags2,
      :ExclusionFlags,
      :nPageRanges,
      :nMaxPageRanges,
      :lpPageRanges,
      :nMinPage,
      :nMaxPage,
      :nCopies,
      :hInstance,
      :lpPrintTemplateName,
      :lpCallback,
      :nPropertyPages,
      :plphPropertyPages,
      :nStartPage,
      :dwResultAction
    )
    pdlg[:lStructSize] = DL.sizeof(PRINTDLGEX_types)
    return pdlg
  end
    
end
end
