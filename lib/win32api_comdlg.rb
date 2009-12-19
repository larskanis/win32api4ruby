# -*- coding: UTF-8 -*-
if __FILE__ == $0
  require 'Win32API'
end

PRINTDLGA = C::Struct.define { 
  DWORD :lStructSize
  HWND :hwndOwner
  HGLOBAL :hDevMode
  HGLOBAL :hDevNames
  HDC :hDC
  DWORD :Flags
  WORD :nFromPage
  WORD :nToPage
  WORD :nMinPage
  WORD :nMaxPage
  WORD :nCopies
  HINSTANCE :hInstance
  LPARAM :lCustData
  LPPRINTHOOKPROC :lpfnPrintHook
  LPSETUPHOOKPROC :lpfnSetupHook
  LPCSTR :lpPrintTemplateName
  LPCSTR :lpSetupTemplateName
  HGLOBAL :hPrintTemplate
  HGLOBAL :hSetupTemplate
}
PRINTDLGW = C::Struct.define { 
  DWORD :lStructSize
  HWND :hwndOwner
  HGLOBAL :hDevMode
  HGLOBAL :hDevNames
  HDC :hDC
  DWORD :Flags
  WORD :nFromPage
  WORD :nToPage
  WORD :nMinPage
  WORD :nMaxPage
  WORD :nCopies
  HINSTANCE :hInstance
  LPARAM :lCustData
  LPPRINTHOOKPROC :lpfnPrintHook
  LPSETUPHOOKPROC :lpfnSetupHook
  LPCWSTR :lpPrintTemplateName
  LPCWSTR :lpSetupTemplateName
  HGLOBAL :hPrintTemplate
  HGLOBAL :hSetupTemplate
}
if Object.const_defined?(:UNICODE)
  PRINTDLG = PRINTDLGW
  LPPRINTDLG = LPPRINTDLGW
else
  PRINTDLG = PRINTDLGA
  #~ LPPRINTDLG = LPPRINTDLGA
end

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


class Win32ApiComDlg  < Win32ApiBase
  COMMDLG32 = DL.dlopen('comdlg32')
  
  #the functions that wrap the Win32API calls enforce type checking on arguments
  # (through #check). This is to be consistent with the Win32API which will assume
  # different arguments are calling different functions, throwing wacky errors
  #API WRAPPERS
  # --------------------------------------------------------------------------------------------------------------
  #~ @@PrintDlg = Win32API.new("comdlg32", "PrintDlg", ['P'], 'N')
  @@PrintDlg = COMMDLG32['PrintDlg', 'Lp']
  def print_dlg(pPrintDlg)
    #~ check(pPrintDlg, String)
    exception_for_0{
      api_call(@@PrintDlg, pPrintDlg)
    }
  end
end

if __FILE__ == $0
end
