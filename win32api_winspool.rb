if __FILE__ == $0
  require 'Win32API'
end

class Winspool < Win32ApiBase
  
  #the functions that wrap the Win32API calls enforce type checking on arguments
  # (through #check). This is to be consistent with the Win32API which will assume
  # different arguments are calling different functions, throwing wacky errors
  #API WRAPPERS
  # --------------------------------------------------------------------------------------------------------------
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
    exception_for_0{
      api_call(@@EnumPrinters, pr, nil, pi, pPrinterEnum, 0, pcbNeeded, pcReturned)
    }
    
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
          averagePPM = *printerattr
          p pointer_to_devmode(pDevMode)
          p pointer_to_s(pServerName)
          p pointer_to_s(pPrinterName)
          p pointer_to_s(pShareName)
          p pointer_to_s(pPortName)
          p pointer_to_s(pDriverName)
          p pointer_to_s(pComment)
          p pointer_to_s(pLocation)
          p pointer_to_s(pServerName)
          p pointer_to_s(pSepFile)
          p pointer_to_s(pPrintProcessor)
          p pointer_to_s(pDatatype)
          p pointer_to_s(pParameters)
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
  # --------------------------------------------------------------------------------------------------------------
  @@OpenPrinter = Win32API.new('winspool.drv', 'OpenPrinter', ['P','P','P'],  'N')
  #~ @@OpenPrinter = WINSPOOL['OpenPrinter', 'LPpP']
  def open_printer(pPrinterName, phPrinter, pDefault)
      #~ BOOL OpenPrinter(
        #~ __in   LPTSTR pPrinterName,
        #~ __out  LPHANDLE phPrinter,
        #~ __in   LPPRINTER_DEFAULTS pDefault
      #~ );      
    check(pPrinterName,String)
    check(phPrinter,String) #handle to string.. return value
    #phPrinter is the PRINTER_DEFAULTS structure.. 0 for default
    # since we want to send through a zero for default, can't enforce string check...
    exception_for_0{
      api_call(@@OpenPrinter, pPrinterName, phPrinter, pDefault)
    }
  end
  # --------------------------------------------------------------------------------------------------------------
  @@ClosePrinter = Win32API.new('winspool.drv', 'ClosePrinter', ['N'], 'N')
  #~ @@ClosePrinter = WINSPOOL['ClosePrinter', 'LL']
  def close_printer(hPrinter)
    check(hPrinter,Integer)
    exception_for_0{
      api_call(@@ClosePrinter, hPrinter)
    }
  end
  # --------------------------------------------------------------------------------------------------------------
  @@AbortPrinter = Win32API.new('winspool.drv', 'AbortPrinter', ['N'], 'N')
  def abort_printer(hPrinter)
    check(hPrinter,Integer)
    exception_for_0{
      api_call(@@AbortPrinter, hPrinter)
    }
  end
  # --------------------------------------------------------------------------------------------------------------
  @@StartDocPrinter = Win32API.new('winspool.drv', 'StartDocPrinter', ['N','N','P'],  'N')
  #~ @@StartDocPrinter = WINSPOOL['StartDocPrinter', 'LLLP']
  def start_doc_printer(hPrinter, level, pDocInfo)
    check(hPrinter, Integer); check(level, Integer); check(pDocInfo, String)
    exception_for_0{
      api_call(@@StartDocPrinter, hPrinter, level, pDocInfo)
    }
  end
  # --------------------------------------------------------------------------------------------------------------
  @@EndDocPrinter = Win32API.new('winspool.drv', 'EndDocPrinter', ['N'], 'N')
  #~ @@EndDocPrinter = WINSPOOL['EndDocPrinter', 'LL']
  def end_doc_printer(hPrinter)
    check(hPrinter, Integer)
    exception_for_0{
      api_call(@@EndDocPrinter, hPrinter)
    }
  end
  # --------------------------------------------------------------------------------------------------------------
  @@StartPagePrinter = Win32API.new('winspool.drv', 'StartPagePrinter', ['N'],  'N')
  #~ @@StartPagePrinter = WINSPOOL['StartPagePrinter', 'LL']
  def start_page_printer(hPrinter)
    check(hPrinter, Integer)
    exception_for_0{
      api_call(@@StartPagePrinter, hPrinter)
    }
  end
  # --------------------------------------------------------------------------------------------------------------
  @@EndPagePrinter = Win32API.new('winspool.drv', 'EndPagePrinter', ['N'], 'N')
  #~ @@EndPagePrinter = WINSPOOL['EndPagePrinter', 'LL']
  def end_page_printer(hPrinter)
    check(hPrinter, Integer)
    exception_for_0{
      api_call(@@EndPagePrinter, hPrinter)
    }
  end
  # --------------------------------------------------------------------------------------------------------------
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
  # --------------------------------------------------------------------------------------------------------------
end

if __FILE__ == $0
end
