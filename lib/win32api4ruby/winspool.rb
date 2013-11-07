# -*- coding: UTF-8 -*-

require 'win32api4ruby/base'

module Win32api4ruby
class Winspool < Base
  extend FFI::Library
  ffi_lib 'winspool.drv'
  ffi_convention :stdcall

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

  attach_function :EnumPrintersA, [ :long, :pointer, :long, :pointer, :long, :pointer, :pointer ], :int
  attach_function :EnumPrintersW, [ :long, :pointer, :long, :pointer, :long, :pointer, :pointer ], :int
  def self.enum_printers(flags, name, level)
    pcbNeeded = FFI::MemoryPointer.new(:long)
    pcReturned = FFI::MemoryPointer.new(:long)
    pcbNeeded.write_long 0

    # erst einmal ermitteln, wieviel Speicher gebraucht wird
    args = flags, name, level, nil, 0, pcbNeeded, pcReturned
    unicode ? EnumPrintersW(*args) : EnumPrintersA(*args)

    # und dann die Infos holen
    cbBuf = pcbNeeded.read_long
#     puts "pcbNeeded: #{cbBuf}"
    pPrinterEnum = FFI::MemoryPointer.new(cbBuf)
    exception_for_0{
      args = flags, name, level, pPrinterEnum, cbBuf, pcbNeeded, pcReturned
      unicode ? EnumPrintersW(*args) : EnumPrintersA(*args)
    }

    #~ p "Laenge des übergebenen Puffers: #{cbBuf}"
    returned = pcReturned.read_long
#     puts "benoetigte Bytes: #{pcbNeeded.read_long}"
#     puts "zurueckgegebene Drucker: #{returned}"

    printers = (0...returned).map{|idx|
      case level
      when PRINTER_INFO_4
        create_PRINTER_INFO_4(pPrinterEnum + idx*PRINTER_INFO_4_struct.size)
      else
        raise "unsupported printer info level #{level.inspect}"
      end
    }
    return printers
  end

  class PRINTER_INFO_4_struct < FFI::Struct
    #   typedef self.struct _PRINTER_INFO_4 {
    #     LPTSTR pPrinterName;
    #     LPTSTR pServerName;
    #     DWORD  Attributes;
    #   }PRINTER_INFO_4, *PPRINTER_INFO_4;
    #
    layout :pPrinterName, :pointer,
      :pServerName, :pointer,
      :Attributes, :uint32
  end

  def self.create_PRINTER_INFO_4(data_or_size=nil)
    create_struct(PRINTER_INFO_4_struct, data_or_size)
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
  attach_function :DocumentPropertiesW, [ :handle, :handle, :pointer, :pointer, :pointer, :uint32 ], :long
  attach_function :DocumentPropertiesA, [ :handle, :handle, :pointer, :pointer, :pointer, :uint32 ], :long
  def self.document_properties(hWnd, hPrinter, deviceName, devModeInput, mode)
    # erst einmal ermitteln, wieviel Speicher gebraucht wird
    bufsize = exception_for_negative{
      args = hWnd, hPrinter, deviceName, nil, devModeInput, 0
      unicode ? DocumentPropertiesW(*args) : DocumentPropertiesA(*args)
    }

    # und dann die Infos holen
    pDevModeOutput = create_DEVMOD(bufsize)
    res = exception_for_negative{
      args = hWnd, hPrinter, deviceName, pDevModeOutput, devModeInput, mode
      unicode ? DocumentPropertiesW(*args) : DocumentPropertiesA(*args)
    }
    if res==IDOK
      return pDevModeOutput
    else
      return nil
    end
  end


  attach_function :OpenPrinterW, [ :pointer, :pointer, :pointer ], :long
  attach_function :OpenPrinterA, [ :pointer, :pointer, :pointer ], :long
  # BOOL OpenPrinter(
  #   __in   LPTSTR pPrinterName,
  #   __out  LPHANDLE phPrinter,
  #   __in   LPPRINTER_DEFAULTS pDefault
  # );
  def self.open_printer(pPrinterName, phPrinter, pDefault)
    check(pPrinterName,String)
    #phPrinter is the PRINTER_DEFAULTS structure.. 0 for default
    # since we want to send through a zero for default, can't enforce string check...
    exception_for_0{
      args = pPrinterName, phPrinter, pDefault
      unicode ? OpenPrinterW(*args) : OpenPrinterA(*args)
    }
  end
  #-----------------------------------------------------------------------------------------------------------------

  attach_function :ClosePrinter, [ :handle ], :int
  def self.close_printer(hPrinter)
    exception_for_0{
      ClosePrinter(hPrinter)
    }
  end
  #-----------------------------------------------------------------------------------------------------------------

  attach_function :AbortPrinter, [ :handle ], :int
  def self.abort_printer(hPrinter)
    exception_for_0{
      AbortPrinter(hPrinter)
    }
  end
  #-----------------------------------------------------------------------------------------------------------------

  attach_function :StartDocPrinterA, [ :handle, :uint32, :pointer ], :uint32
  attach_function :StartDocPrinterW, [ :handle, :uint32, :pointer ], :uint32
  def self.start_doc_printer(hPrinter, level, pDocInfo)
    check(level, Integer);
#    check(pDocInfo, String)
    exception_for_0{
      args = hPrinter, level, pDocInfo
      unicode ? StartDocPrinterW(*args) : StartDocPrinterA(*args)
    }
  end
  #-----------------------------------------------------------------------------------------------------------------

  attach_function :EndDocPrinter, [ :handle ], :int
  def self.end_doc_printer(hPrinter)
    exception_for_0{
      EndDocPrinter(hPrinter)
    }
  end
  #-----------------------------------------------------------------------------------------------------------------

  attach_function :StartPagePrinter, [ :handle ], :int
  def self.start_page_printer(hPrinter)
    exception_for_0{
      StartPagePrinter(hPrinter)
    }
  end
  #-----------------------------------------------------------------------------------------------------------------

  attach_function :EndPagePrinter, [ :handle ], :int
  def self.end_page_printer(hPrinter)
    exception_for_0{
      EndPagePrinter(hPrinter)
    }
  end
  #-----------------------------------------------------------------------------------------------------------------

  attach_function :GetPrinterA, [ :handle, :uint32, :pointer, :uint32, :pointer ], :int
  attach_function :GetPrinterW, [ :handle, :uint32, :pointer, :uint32, :pointer ], :int
  def self.get_printer(hPrinter, level, pPrinter, cbBuf, pcbNeeded)
    #~ BOOL GetPrinter(
      #~ __in   HANDLE hPrinter,
      #~ __in   DWORD Level,
      #~ __out  LPBYTE pPrinter,
      #~ __in   DWORD cbBuf,
      #~ __out  LPDWORD pcbNeeded
    #~ );
    #~ exception_for_0{
      args = hPrinter, level, pPrinter, cbBuf, pcbNeeded
      unicode ? GetPrinterW(*args) : GetPrinterA(*args)
    #~ }
  end

#-----------------------------------------------------------------------------------------------------------------

  attach_function :WritePrinter, [ :handle, :pointer, :uint32, :pointer ], :int
	def self.write_printer(hPrinter, pBuf)
    #~ BOOL WritePrinter(
    #~ __in   HANDLE hPrinter,
    #~ __in   LPVOID pBuf,
    #~ __in   DWORD cbBuf,
    #~ __out  LPDWORD pcWritten
    #~ );
		pcWritten = FFI::MemoryPointer.new :uint32
    exception_for_0{
      WritePrinter(hPrinter, pBuf, pBuf.length, pcWritten)
		}
		pcWritten.read_uint32
  end

  class DOC_INFO_1W < FFI::Struct
    layout :pDocName, :pointer,
      :pOutputFile, :pointer,
      :pDatatype, :pointer
  end

  class DOC_INFO_1A < FFI::Struct
    layout :pDocName, :pointer,
      :pOutputFile, :pointer,
      :pDatatype, :pointer
  end

	def self.create_DOC_INFO_1(data_or_size=nil)
    create_struct(unicode ? DOC_INFO_1W : DOC_INFO_1A, data_or_size)
	end

#-----------------------------------------------------------------------------------------------------------------

  class DEVMODW < FFI::Struct
    layout :dmDeviceName, [:uint16, 32],
      :dmSpecVersion, :uint16,
      :dmDriverVersion, :uint16,
      :dmSize, :uint16,
      :dmDriverExtra, :uint16,
      :dmFields, :uint32,
          :dmOrientation, :int16,
          :dmPaperSize, :int16,
          :dmPaperLength, :int16,
          :dmPaperWidth, :int16,
          :dmScale, :int16,
          :dmCopies, :int16,
          :dmDefaultSource, :int16,
          :dmPrintQuality, :int16,
      :dmColor, :int16,
      :dmDuplex, :int16,
      :dmYResolution, :int16,
      :dmTTOption, :int16,
      :dmCollate, :int16,
      :dmFormName, [:uint16, 32],
      :dmLogPixels, :uint16,
      :dmBitsPerPel, :uint32,
      :dmPelsWidth, :uint32,
      :dmPelsHeight, :uint32,
        :dmNup, :uint32,
      :dmDisplayFrequency, :uint32,
      :dmICMMethod, :uint32,
      :dmICMIntent, :uint32,
      :dmMediaType, :uint32,
      :dmDitherType, :uint32,
      :dmReserved1, :uint32,
      :dmReserved2, :uint32,
      :dmPanningWidth, :uint32,
      :dmPanningHeight, :uint32
  end

  class DEVMODA < FFI::Struct
    layout :dmDeviceName, [:uint8, 32],
      :dmSpecVersion, :uint16,
      :dmDriverVersion, :uint16,
      :dmSize, :uint16,
      :dmDriverExtra, :uint16,
      :dmFields, :uint32,
          :dmOrientation, :int16,
          :dmPaperSize, :int16,
          :dmPaperLength, :int16,
          :dmPaperWidth, :int16,
          :dmScale, :int16,
          :dmCopies, :int16,
          :dmDefaultSource, :int16,
          :dmPrintQuality, :int16,
      :dmColor, :int16,
      :dmDuplex, :int16,
      :dmYResolution, :int16,
      :dmTTOption, :int16,
      :dmCollate, :int16,
      :dmFormName, [:uint8, 32],
      :dmLogPixels, :uint16,
      :dmBitsPerPel, :uint32,
      :dmPelsWidth, :uint32,
      :dmPelsHeight, :uint32,
        :dmNup, :uint32,
      :dmDisplayFrequency, :uint32,
      :dmICMMethod, :uint32,
      :dmICMIntent, :uint32,
      :dmMediaType, :uint32,
      :dmDitherType, :uint32,
      :dmReserved1, :uint32,
      :dmReserved2, :uint32,
      :dmPanningWidth, :uint32,
      :dmPanningHeight, :uint32
  end

  def self.create_DEVMOD(data_or_size=nil)
    create_struct(unicode ? DEVMODW : DEVMODA, data_or_size)
  end
end
end
