# -*- coding: UTF-8 -*-

require 'win32api4ruby/base'

module Win32api4ruby
class Winspool < Base
  PRINTER_ENUM_DEFAULT = 0x00000001
  PRINTER_ENUM_LOCAL = 0x00000002
  PRINTER_ENUM_CONNECTIONS = 0x00000004
  PRINTER_ENUM_FAVORITE = 0x00000004
  PRINTER_ENUM_NAME = 0x00000008
  PRINTER_ENUM_REMOTE = 0x00000010
  PRINTER_ENUM_SHARED = 0x00000020
  PRINTER_ENUM_NETWORK = 0x00000040

  PRINTER_INFO_1 = 1
  PRINTER_INFO_2 = 2
  PRINTER_INFO_3 = 3
  PRINTER_INFO_4 = 4
  PRINTER_INFO_5 = 5

  DM_PROMPT = 4
  DM_IN_PROMPT = DM_PROMPT
  DM_MODIFY = 8
  DM_IN_BUFFER = DM_MODIFY
  DM_COPY = 2
  DM_OUT_BUFFER = DM_COPY

  IDOK = 1
  IDCANCEL = 2
  
  WINSPOOL = DL.dlopen('winspool.drv')
  
  EnumPrintersA = WINSPOOL['EnumPrintersA', 'LLPLpLpp']
  EnumPrintersW = WINSPOOL['EnumPrintersW', 'LLPLpLpp']
  def self.enum_printers(flags, name, level)
    pcbNeeded = DL.malloc(DL.sizeof('L'))
    pcbNeeded.struct!('L', :size)
    pcReturned = DL.malloc(DL.sizeof('L'))
    pcReturned.struct!('L', :size)
    pcbNeeded[:size] = 0
    
    # erst einmal ermitteln, wieviel Speicher gebraucht wird
    api_call(unicode ? EnumPrintersW : EnumPrintersA, flags, name, level, nil, 0, pcbNeeded, pcReturned)
    
    # und dann die Infos holen
    cbBuf = pcbNeeded[:size]
#     puts "pcbNeeded: #{cbBuf}"
    pPrinterEnum = DL.malloc(cbBuf)
    exception_for_0{
      api_call(unicode ? EnumPrintersW : EnumPrintersA, flags, name, level, pPrinterEnum, cbBuf, pcbNeeded, pcReturned)
    }
    
    #~ p "Laenge des übergebenen Puffers: #{cbBuf}"
    needed = pcbNeeded[:size]
    returned = pcReturned[:size]
#     puts "benoetigte Bytes: #{needed}"
#     puts "zurueckgegebene Drucker: #{returned}"

    printers = (0...returned).map{|idx|
      case level
      when PRINTER_INFO_4
        create_PRINTER_INFO_4(pPrinterEnum + idx*DL.sizeof(PRINTER_INFO_4_types))
      else
        raise "unsupported printer info level #{level.inspect}"
      end
    }
    return printers
  end

  PRINTER_INFO_4_types = 'PPL'
  
  #   typedef self.struct _PRINTER_INFO_4 {
  #     LPTSTR pPrinterName;
  #     LPTSTR pServerName;
  #     DWORD  Attributes;
  #   }PRINTER_INFO_4, *PPRINTER_INFO_4;
  #
  def self.create_PRINTER_INFO_4(mem)
    mem ||= DL.malloc(DL.sizeof(PRINTER_INFO_4_types))
    mem.struct!(PRINTER_INFO_4_types,
      :pPrinterName,
      :pServerName,
      :Attributes)
    return mem
  end


  # LONG DocumentProperties(
  #   __in   HWND hWnd,
  #   __in   HANDLE hPrinter,
  #   __in   LPTSTR pDeviceName,
  #   __out  PDEVMODE pDevModeOutput,
  #   __in   PDEVMODE pDevModeInput,
  #   __in   DWORD fMode
  # );
  # 
  DocumentPropertiesW = WINSPOOL['DocumentPropertiesW', 'LLLPpPL']
  DocumentPropertiesA = WINSPOOL['DocumentPropertiesA', 'LLLPpPL']
  def self.document_properties(hWnd, hPrinter, deviceName, devModeInput, mode)
    # erst einmal ermitteln, wieviel Speicher gebraucht wird
    bufsize = api_call(unicode ? DocumentPropertiesW : DocumentPropertiesA, hWnd, hPrinter, deviceName, nil, devModeInput, 0)

    # und dann die Infos holen
    pDevModeOutput = create_DEVMOD(nil, bufsize)
    res = exception_for_negative{
      api_call(unicode ? DocumentPropertiesW : DocumentPropertiesA, hWnd, hPrinter, deviceName, pDevModeOutput, devModeInput, mode)
    }
    if res==IDOK
      return pDevModeOutput
    else
      return nil
    end
  end
  
  
  OpenPrinterW = WINSPOOL['OpenPrinterW', 'LPpP']
  OpenPrinterA = WINSPOOL['OpenPrinterA', 'LPpP']
  def self.open_printer(pPrinterName, phPrinter, pDefault)
      #~ BOOL OpenPrinter(
        #~ __in   LPTSTR pPrinterName,
        #~ __out  LPHANDLE phPrinter,
        #~ __in   LPPRINTER_DEFAULTS pDefault
      #~ );      
    check(pPrinterName,String)
    #~ check(phPrinter,String) #handle to string.. return value
    #phPrinter is the PRINTER_DEFAULTS structure.. 0 for default
    # since we want to send through a zero for default, can't enforce string check...
    exception_for_0{
      p "."*10
      p pPrinterName
      p phPrinter
      p pDefault
      p "."*10
      api_call(unicode ? OpenPrinterW : OpenPrinterA, pPrinterName, phPrinter, pDefault)
    }
  end
  #-----------------------------------------------------------------------------------------------------------------
  
  ClosePrinter = WINSPOOL['ClosePrinter', 'LL']
  def self.close_printer(hPrinter)
    check(hPrinter,Integer)
    exception_for_0{
      api_call(ClosePrinter, hPrinter)
    }
  end
  #-----------------------------------------------------------------------------------------------------------------
  
  AbortPrinter = WINSPOOL['AbortPrinter', 'LL']
  def self.abort_printer(hPrinter)
    check(hPrinter,Integer)
    exception_for_0{
      api_call(AbortPrinter, hPrinter)
    }
  end
  #-----------------------------------------------------------------------------------------------------------------
  
  StartDocPrinter = WINSPOOL['StartDocPrinter', 'LLLP']
  def self.start_doc_printer(hPrinter, level, pDocInfo)
    check(hPrinter, Integer); 
    check(level, Integer); 
    check(pDocInfo, String)
    exception_for_0{
      api_call(StartDocPrinter, hPrinter, level, pDocInfo)
    }
  end
  #-----------------------------------------------------------------------------------------------------------------
  
  EndDocPrinter = WINSPOOL['EndDocPrinter', 'LL']
  def self.end_doc_printer(hPrinter)
    check(hPrinter, Integer)
    exception_for_0{
      api_call(EndDocPrinter, hPrinter)
    }
  end
  #-----------------------------------------------------------------------------------------------------------------
  
  StartPagePrinter = WINSPOOL['StartPagePrinter', 'LL']
  def self.start_page_printer(hPrinter)
    check(hPrinter, Integer)
    exception_for_0{
      api_call(StartPagePrinter, hPrinter)
    }
  end
  #-----------------------------------------------------------------------------------------------------------------
  
  EndPagePrinter = WINSPOOL['EndPagePrinter', 'LL']
  def self.end_page_printer(hPrinter)
    check(hPrinter, Integer)
    exception_for_0{
      api_call(EndPagePrinter, hPrinter)
    }
  end
  #-----------------------------------------------------------------------------------------------------------------
  
  WritePrinter = WINSPOOL['WritePrinter', 'LLPLp']
  def self.write_printer(hPrinter, pBuf, cdBuf, pcWritten)
      #~ BOOL WritePrinter(
        #~ __in   HANDLE hPrinter,
        #~ __in   LPVOID pBuf,
        #~ __in   DWORD cbBuf,
        #~ __out  LPDWORD pcWritten
      #~ );
    check(hPrinter,Integer); check(pBuf,String);
    check(cdBuf,Integer);check(pcWritten,String)
    exception_for_0{
      api_call(WritePrinter, hPrinter, pBuf, cdBuf, pcWritten)
    }
  end
  #-----------------------------------------------------------------------------------------------------------------
  
  GetPrinter = WINSPOOL['GetPrinter', 'LLLpLp']
  def self.get_printer(hPrinter, level, pPrinter, cbBuf, pcbNeeded)
    #~ BOOL GetPrinter(
      #~ __in   HANDLE hPrinter,
      #~ __in   DWORD Level,
      #~ __out  LPBYTE pPrinter,
      #~ __in   DWORD cbBuf,
      #~ __out  LPDWORD pcbNeeded
    #~ );
    #~ exception_for_0{
      api_call(GetPrinter, hPrinter, level, pPrinter, cbBuf, pcbNeeded)
    #~ }
  end
  #-----------------------------------------------------------------------------------------------------------------

  DEVMODW_types = 'H32HHHHI' + 'H'*8 + 'H'*5 + 'H32H' + 'I'*13
  DEVMODA_types = 'C32HHHHI' + 'H'*8 + 'H'*5 + 'C32H' + 'I'*13
  def self.create_DEVMOD(ptrdata=nil, size=nil)
    ptrdata = prepare_PtrData(ptrdata, size || DL.sizeof(unicode ? DEVMODW_types : DEVMODA_types))
    ptrdata.struct!(unicode ? DEVMODW_types : DEVMODA_types, 
      :dmDeviceName,
      :dmSpecVersion,
      :dmDriverVersion,
      :dmSize,
      :dmDriverExtra,
      :dmFields,
          :dmOrientation,
          :dmPaperSize,
          :dmPaperLength,
          :dmPaperWidth,
          :dmScale,
          :dmCopies,
          :dmDefaultSource,
          :dmPrintQuality,
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
        :dmNup,
      :dmDisplayFrequency,
      :dmICMMethod,
      :dmICMIntent,
      :dmMediaType,
      :dmDitherType,
      :dmReserved1,
      :dmReserved2,
      :dmPanningWidth,
      :dmPanningHeight)
    return ptrdata
  end
end
end
