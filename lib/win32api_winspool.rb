# -*- coding: UTF-8 -*-

require 'Win32API_base'

class Win32ApiWinspool < Win32ApiBase
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
  
  @@EnumPrinters = WINSPOOL['EnumPrinters', 'LLPLpLpp']
  def enum_printers(flags, name, level)
    pcbNeeded = DL.malloc(DL.sizeof('L'))
    pcbNeeded.struct!('L', :size)
    pcReturned = DL.malloc(DL.sizeof('L'))
    pcReturned.struct!('L', :size)
    pcbNeeded[:size] = 0
    
    # erst einmal ermitteln, wieviel Speicher gebraucht wird
    api_call(@@EnumPrinters, flags, name, level, nil, 0, pcbNeeded, pcReturned)
    
    # und dann die Infos holen
    cbBuf = pcbNeeded[:size]
#     puts "pcbNeeded: #{cbBuf}"
    pPrinterEnum = DL.malloc(cbBuf)
    exception_for_0{
      api_call(@@EnumPrinters, flags, name, level, pPrinterEnum, cbBuf, pcbNeeded, pcReturned)
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
  
  #   typedef struct _PRINTER_INFO_4 {
  #     LPTSTR pPrinterName;
  #     LPTSTR pServerName;
  #     DWORD  Attributes;
  #   }PRINTER_INFO_4, *PPRINTER_INFO_4;
  #
  def create_PRINTER_INFO_4(mem)
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
  @@DocumentProperties = WINSPOOL['DocumentProperties', 'LLLPpPL']
  def document_properties(hWnd, hPrinter, deviceName, devModeInput, mode)
    # erst einmal ermitteln, wieviel Speicher gebraucht wird
    bufsize = api_call(@@DocumentProperties, hWnd, hPrinter, deviceName, nil, devModeInput, 0)

    # und dann die Infos holen
    pDevModeOutput = DL.malloc(bufsize)
    res = exception_for_negative{
      api_call(@@DocumentProperties, hWnd, hPrinter, deviceName, pDevModeOutput, devModeInput, mode)
    }
    if res==IDOK
      return pDevModeOutput[0, bufsize]
    else
      return nil
    end
  end
  
  
  @@OpenPrinter = WINSPOOL['OpenPrinter', 'LPpP']
  def open_printer(pPrinterName, phPrinter, pDefault)
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
      api_call(@@OpenPrinter, pPrinterName, phPrinter, pDefault)
    }
  end
  #-----------------------------------------------------------------------------------------------------------------
  
  @@ClosePrinter = WINSPOOL['ClosePrinter', 'LL']
  def close_printer(hPrinter)
    check(hPrinter,Integer)
    exception_for_0{
      api_call(@@ClosePrinter, hPrinter)
    }
  end
  #-----------------------------------------------------------------------------------------------------------------
  
  @@AbortPrinter = Win32API.new('winspool.drv', 'AbortPrinter', ['N'], 'N')
  def abort_printer(hPrinter)
    check(hPrinter,Integer)
    exception_for_0{
      api_call(@@AbortPrinter, hPrinter)
    }
  end
  #-----------------------------------------------------------------------------------------------------------------
  
  @@StartDocPrinter = WINSPOOL['StartDocPrinter', 'LLLP']
  def start_doc_printer(hPrinter, level, pDocInfo)
    check(hPrinter, Integer); 
    check(level, Integer); 
    check(pDocInfo, String)
    exception_for_0{
      api_call(@@StartDocPrinter, hPrinter, level, pDocInfo)
    }
  end
  #-----------------------------------------------------------------------------------------------------------------
  
  @@EndDocPrinter = WINSPOOL['EndDocPrinter', 'LL']
  def end_doc_printer(hPrinter)
    check(hPrinter, Integer)
    exception_for_0{
      api_call(@@EndDocPrinter, hPrinter)
    }
  end
  #-----------------------------------------------------------------------------------------------------------------
  
  @@StartPagePrinter = WINSPOOL['StartPagePrinter', 'LL']
  def start_page_printer(hPrinter)
    check(hPrinter, Integer)
    exception_for_0{
      api_call(@@StartPagePrinter, hPrinter)
    }
  end
  #-----------------------------------------------------------------------------------------------------------------
  
  @@EndPagePrinter = WINSPOOL['EndPagePrinter', 'LL']
  def end_page_printer(hPrinter)
    check(hPrinter, Integer)
    exception_for_0{
      api_call(@@EndPagePrinter, hPrinter)
    }
  end
  #-----------------------------------------------------------------------------------------------------------------
  
  @@WritePrinter = WINSPOOL['WritePrinter', 'LLPLp']
  def write_printer(hPrinter, pBuf, cdBuf, pcWritten)
      #~ BOOL WritePrinter(
        #~ __in   HANDLE hPrinter,
        #~ __in   LPVOID pBuf,
        #~ __in   DWORD cbBuf,
        #~ __out  LPDWORD pcWritten
      #~ );
    check(hPrinter,Integer); check(pBuf,String);
    check(cdBuf,Integer);check(pcWritten,String)
    exception_for_0{
      api_call(@@WritePrinter, hPrinter, pBuf, cdBuf, pcWritten)
    }
  end
  #-----------------------------------------------------------------------------------------------------------------
  
  @@GetPrinter = WINSPOOL['GetPrinter', 'LLLpLp']
  def get_printer(hPrinter, level, pPrinter, cbBuf, pcbNeeded)
    #~ BOOL GetPrinter(
      #~ __in   HANDLE hPrinter,
      #~ __in   DWORD Level,
      #~ __out  LPBYTE pPrinter,
      #~ __in   DWORD cbBuf,
      #~ __out  LPDWORD pcbNeeded
    #~ );
    #~ exception_for_0{
      api_call(@@GetPrinter, hPrinter, level, pPrinter, cbBuf, pcbNeeded)
    #~ }
  end
  #-----------------------------------------------------------------------------------------------------------------
begin
  
  @@DeviceCapabilities = Win32API.new('winspool.drv', 'DeviceCapabilities', ['P','P','N','p','P'], 'N')
  def device_capabilities(pDevice, pPort, fwCapability, pOutput, pDevMode)
      #~ DWORD DeviceCapabilities(
        #~ __in   LPCTSTR pDevice,
        #~ __in   LPCTSTR pPort,
        #~ __in   WORD fwCapability,
        #~ __out  LPTSTR pOutput,
        #~ __in   const DEVMODE *pDevMode
      #~ );
    exception_for_0{
      api_call(@@DeviceCapabilities, pPort, fwCapability, pOutput, pDevMode)
    }
  end
end
end

#=====================================================================================================================

if __FILE__ == $0
  require "win32api_gdi"
  w32gdi = Win32ApiGDI.new
  
  ws = Winspool.new
  ws.enum_printers
  exit
  
  #~ szPrnName = "DIGID XID440\0"
  szPrnName = "\\\\comfile1\\P0049\0"
  pcbNeeded = "\0" * 4


  #~ hPrinter = nil
  #~ ws.exception_for_0{
    #~ hPrinter = w32gdi.create_dc( nil, szPrnName, nil, nil);
  #~ }
  #~ p hPrinter
  
  #~ fwCapability
  #~ ws.device_capabilities(szPrnName, "", , pOutput, pDevMode)
  
  level = PRINTER_INFO_2
  
  phPrinter = "\0" * 4
  #~ pDefault = 0
  pDefault = ["TEXT\0", szPrnName.to_s, 0x8].pack('ppL')
  
  ws.open_printer(szPrnName, phPrinter, pDefault)
  
  p "phPrinter #{phPrinter.inspect}"
  hPrinter = phPrinter.unpack("V")[0]

  # ............................................................................................
  # erst einmal ermitteln, wieviel Speicher gebraucht wird
  cbBuf = 0
  pPrinter = "\0" * cbBuf # Buffer für die Datenübergabe aufbereiten
  
  #~ ws.exception_for_0{
    ws.get_printer(hPrinter, level, pPrinter, cbBuf, pcbNeeded)
  #~ }
  p "pcbNeeded: #{pcbNeeded.unpack("V")[0]}"
  
  # ............................................................................................
  # und dann die Infos holen
  cbBuf = pcbNeeded.unpack("V")[0] + 1
  #~ pPrinter = DL.malloc(cbBuf)
  pPrinter = "\0" * cbBuf # Buffer für die Datenübergabe aufbereiten
  ws.exception_for_0{
    ws.get_printer(hPrinter, level, pPrinter, cbBuf, pcbNeeded)
  }
  #~ p "pcbNeeded: #{pcbNeeded.unpack("V")[0]}"
  p "cbBuf: #{cbBuf}"
  
  # ............................................................................................
  # 
  pDevMode = DL.malloc(DL.sizeof(Win32ApiBase::DevmodStructur.struct_def))
  anz_attr = 21
  printerattrs = pPrinter.unpack("V" * anz_attr)
          pServerName,
          pPrinterName,
          pShareName,
          pPortName,
          pDriverName,
          pComment,
          pLocation,
          pDevMode,
          pSepFile,
          pPrintProcessor,
          pDatatype,
          pParameters,
          pSecurityDescriptor,
          attributes,
          priority,
          defaultPriority,
          startTime,
          untilTime,
          status,
          cJobs,
          averagePPM = *printerattrs
          p ws.pointer_to_s(pServerName)
          p ws.pointer_to_s(pPrinterName)
  #~ PRINTER_INFO_2_STRUCT.new(pPrinter)
  #~ exit
  
  #~ p pDevMode
  #~ dm_struct = DL.malloc(DL.sizeof(Win32ApiBase::DevmodStructur.struct_def))
  p pDevMode
  #~ dms = pDevMode.unpack("V" * anz_attr)
  point = DL::PtrData.new(pDevMode, DL.sizeof(Win32ApiBase::DevmodStructur.struct_def))  
  p point
  dms = Win32ApiBase::DevmodStructur.new(point).get_struct
  p "devmod"
  p dms[:dmDeviceName]
  p dms[:dmDriverVersion]
  p dms[:dmSize]
  p dms[:dmDuplex]
  p dms[:dmYResolution]
  
=begin
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
              :dmPosition,
              :dmDisplayOrientation,
              :dmDisplayFixedOutput,
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
            :dmDisplayFlags,
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
=end
  
end
