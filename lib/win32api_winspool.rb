# -*- coding: UTF-8 -*-

if __FILE__ == $0
  require 'Win32API'
end

require 'Win32API_base'

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

class PRINTER_INFO_2_STRUCT < Win32ApiBase
  def initialize(printerattr)
          #~ pServerName,
          #~ pPrinterName,
          #~ pShareName,
          #~ pPortName,
          #~ pDriverName,
          #~ pComment,
          #~ pLocation,
          #~ pDevMode,
          #~ pSepFile,
          #~ pPrintProcessor,
          #~ pDatatype,
          #~ pParameters,
          #~ pSecurityDescriptor,
          #~ attributes,
          #~ priority,
          #~ defaultPriority,
          #~ startTime,
          #~ untilTime,
          #~ status,
          #~ cJobs,
          #~ averagePPM = *printerattr
          #~ p pointer_to_devmode(pDevMode)
          
          #~ p "pDevMode #{pDevMode.inspect}"
          #~ p "pPrinterName #{}"
          #~ p pointer_to_s(pDevMode)
          #~ p pointer_to_s(pServerName)
          #~ p pointer_to_s(pPrinterName)
          #~ p pointer_to_s(pShareName)
          #~ p pointer_to_s(pPortName)
          #~ p pointer_to_s(pDriverName)
          #~ p pointer_to_s(pComment)
          #~ p pointer_to_s(pLocation)
          #~ p pointer_to_s(pServerName)
          #~ p pointer_to_s(pSepFile)
          #~ p pointer_to_s(pPrintProcessor)
          #~ p pointer_to_s(pDatatype)
          #~ p pointer_to_s(pParameters)
          
      printerattr.struct!("L"*21,
          :pServerName,
          :pPrinterName,
          :pShareName,
          :pPortName,
          :pDriverName,
          :pComment,
          :pLocation,
          :pDevMode,
          :pSepFile,
          :pPrintProcessor,
          :pDatatype,
          :pParameters,
          :pSecurityDescriptor,
          :attributes,
          :priority,
          :defaultPriority,
          :startTime,
          :untilTime,
          :status,
          :cJobs,
          :averagePPM
      )
      p pointer_to_s(printerattr[:pServerName])
      p pointer_to_s(printerattr[:pPrinterName])
      p pointer_to_s(printerattr[:status])
  end
end

class Winspool < Win32ApiBase
  WINSPOOL = DL.dlopen('winspool.drv')
  #the functions that wrap the Win32API calls enforce type checking on arguments
  # (through #check). This is to be consistent with the Win32API which will assume
  # different arguments are calling different functions, throwing wacky errors
  #API WRAPPERS
  #-----------------------------------------------------------------------------------------------------------------
  
  @@EnumPrinters = Win32API.new('winspool.drv', 'EnumPrinters', ['N', 'P', 'N', 'P', 'N', 'P', 'P'], 'N')
  #~ @@EnumPrinters = WINSPOOL['EnumPrinters', 'LLPLpLpp']
  def enum_printers()
      #~ __in   DWORD Flags,
      #~ __in   LPTSTR Name,
      #~ __in   DWORD Level,
      #~ __out  LPBYTE pPrinterEnum,
      #~ __in   DWORD cbBuf,
      #~ __out  LPDWORD pcbNeeded,
      #~ __out  LPDWORD pcReturned
      
    pcbNeeded = "\0" * 4
    pcReturned = "\0" * 4
    pr = 
    #~ PRINTER_ENUM_DEFAULT |
    PRINTER_ENUM_LOCAL |
    PRINTER_ENUM_CONNECTIONS |
    PRINTER_ENUM_FAVORITE |
    #~ PRINTER_ENUM_NAME |
    #~ PRINTER_ENUM_REMOTE |
    #~ PRINTER_ENUM_SHARED |
    #~ PRINTER_ENUM_NETWORK |
    #~ PRINTER_ENUM_EXPAND |
    #~ PRINTER_ENUM_CONTAINER |
    #~ PRINTER_ENUM_ICONMASK |
    0 # Dummy
    
    #~ pi = PRINTER_INFO_1
    pi = PRINTER_INFO_2
    #~ pi = PRINTER_INFO_4
    #~ pi = PRINTER_INFO_5
    
    # erst einmal ermitteln, wieviel Speicher gebraucht wird
    cbBuf = 0
    pPrinterEnum = "\0" * cbBuf # Buffer
    #~ exception_for_0{
      api_call(@@EnumPrinters, pr, nil, pi, pPrinterEnum, 0, pcbNeeded, pcReturned)
    #~ }
    
    # und dann die Infos holen
    cbBuf = pcbNeeded.unpack("V")[0] + 1
    
    pPrinterEnum = "\0" * cbBuf # Buffer für die Datenübergabe aufbereiten
    
    exception_for_0{
      api_call(@@EnumPrinters, pr, nil, pi, pPrinterEnum, cbBuf, pcbNeeded, pcReturned)
    }
    
    #~ p "Laenge des übergebenen Puffers: #{cbBuf}"
    needed = pcbNeeded.unpack("V")[0]
    returned = pcReturned.unpack("V")[0]
    #~ p "benoetigte Bytes: #{needed}"
    #~ p "zurueckgegebene Drucker: #{returned}"
    if returned > 0
      if pi == PRINTER_INFO_1
        #~ typedef struct _PRINTER_INFO_1 {
          #~ DWORD  Flags;
          #~ LPTSTR pDescription;
          #~ LPTSTR pName;
          #~ LPTSTR pComment;
        #~ } PRINTER_INFO_1, *PPRINTER_INFO_1;

        anz_attr = 4
        printerattrs = pPrinterEnum.unpack("V" * anz_attr * returned)
        while (printerattr=printerattrs.slice!(0, anz_attr)) && !printerattr.empty?
          p "*"*50
          flags, pDescription, pName, pComment = *printerattr
          p pointer_to_s(pDescription)
          p pointer_to_s(pName)
          p pointer_to_s(pComment)
        end
      elsif pi == PRINTER_INFO_2
        #~ typedef struct _PRINTER_INFO_2 {
          #~ LPTSTR               pServerName;
          #~ LPTSTR               pPrinterName;
          #~ LPTSTR               pShareName;
          #~ LPTSTR               pPortName;
          #~ LPTSTR               pDriverName;
          #~ LPTSTR               pComment;
          #~ LPTSTR               pLocation;
          #~ LPDEVMODE            pDevMode;
          #~ LPTSTR               pSepFile;
          #~ LPTSTR               pPrintProcessor;
          #~ LPTSTR               pDatatype;
          #~ LPTSTR               pParameters;
          #~ PSECURITY_DESCRIPTOR pSecurityDescriptor;
          #~ DWORD                Attributes;
          #~ DWORD                Priority;
          #~ DWORD                DefaultPriority;
          #~ DWORD                StartTime;
          #~ DWORD                UntilTime;
          #~ DWORD                Status;
          #~ DWORD                cJobs;
          #~ DWORD                AveragePPM;
        #~ } PRINTER_INFO_2, *PPRINTER_INFO_2;
        anz_attr = 21
        printerattrs = pPrinterEnum.unpack("V" * anz_attr * returned)
        while (printerattr=printerattrs.slice!(0, anz_attr)) && !printerattr.empty?
          p "*"*50
          PRINTER_INFO_2_STRUCT.new(printerattr)
        end
      elsif pi == PRINTER_INFO_4
        #~ typedef struct _PRINTER_INFO_4 {
          #~ LPTSTR pPrinterName;
          #~ LPTSTR pServerName;
          #~ DWORD  Attributes;
        #~ } PRINTER_INFO_4, *PPRINTER_INFO_4;
        anz_attr = 3
        printerattrs = pPrinterEnum.unpack("V" * anz_attr * returned)
        while (printerattr=printerattrs.slice!(0, anz_attr)) && !printerattr.empty?
          p "*"*50
          pPrinterName,
          pServerName,
          attributes = *printerattr
          p pointer_to_s(pPrinterName)
        end
      elsif pi == PRINTER_INFO_5
        #~ typedef struct _PRINTER_INFO_5 {
          #~ LPTSTR pPrinterName;
          #~ LPTSTR pPortName;
          #~ DWORD  Attributes;
          #~ DWORD  DeviceNotSelectedTimeout;
          #~ DWORD  TransmissionRetryTimeout;
        #~ } PRINTER_INFO_5, *PPRINTER_INFO_5;
        anz_attr = 5
        printerattrs = pPrinterEnum.unpack("V" * anz_attr * returned)
        while (printerattr=printerattrs.slice!(0, anz_attr)) && !printerattr.empty?
          p "*"*50
          pPrinterName,
          pPortName,
          attributes,
          deviceNotSelectedTimeout,
          transmissionRetryTimeout = *printerattr
          p pointer_to_s(pPortName)
        end
      end
    end
  end
  #-----------------------------------------------------------------------------------------------------------------
  
#  @@OpenPrinter = WINSPOOL['OpenPrinter', 'LPpP']
  @@OpenPrinter = Win32API.new('winspool.drv', 'OpenPrinter',['P','P','P'],  'N')
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
  
  @@ClosePrinter = Win32API.new('winspool.drv', 'ClosePrinter', ['N'], 'N')
  #~ @@ClosePrinter = WINSPOOL['ClosePrinter', 'LL']
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
  
  @@StartDocPrinter = Win32API.new('winspool.drv', 'StartDocPrinter', ['N','N','P'],  'N')
  #~ @@StartDocPrinter = WINSPOOL['StartDocPrinter', 'LLLP']
  def start_doc_printer(hPrinter, level, pDocInfo)
    check(hPrinter, Integer); 
    check(level, Integer); 
    check(pDocInfo, String)
    exception_for_0{
      api_call(@@StartDocPrinter, hPrinter, level, pDocInfo)
    }
  end
  #-----------------------------------------------------------------------------------------------------------------
  
  @@EndDocPrinter = Win32API.new('winspool.drv', 'EndDocPrinter', ['N'], 'N')
  #~ @@EndDocPrinter = WINSPOOL['EndDocPrinter', 'LL']
  def end_doc_printer(hPrinter)
    check(hPrinter, Integer)
    exception_for_0{
      api_call(@@EndDocPrinter, hPrinter)
    }
  end
  #-----------------------------------------------------------------------------------------------------------------
  
  @@StartPagePrinter = Win32API.new('winspool.drv', 'StartPagePrinter', ['N'],  'N')
  #~ @@StartPagePrinter = WINSPOOL['StartPagePrinter', 'LL']
  def start_page_printer(hPrinter)
    check(hPrinter, Integer)
    exception_for_0{
      api_call(@@StartPagePrinter, hPrinter)
    }
  end
  #-----------------------------------------------------------------------------------------------------------------
  
  @@EndPagePrinter = Win32API.new('winspool.drv', 'EndPagePrinter', ['N'], 'N')
  #~ @@EndPagePrinter = WINSPOOL['EndPagePrinter', 'LL']
  def end_page_printer(hPrinter)
    check(hPrinter, Integer)
    exception_for_0{
      api_call(@@EndPagePrinter, hPrinter)
    }
  end
  #-----------------------------------------------------------------------------------------------------------------
  
  @@WritePrinter = Win32API.new('winspool.drv', 'WritePrinter', ['N','P','N','P'],  'N')
  #~ @@WritePrinter = WINSPOOL['WritePrinter', 'LLPLp']
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
  
  @@GetPrinter = Win32API.new('winspool.drv', 'GetPrinter', ['N','N','p','N', 'p'],  'N')
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
