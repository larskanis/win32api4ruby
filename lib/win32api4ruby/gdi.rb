# -*- coding: UTF-8 -*-

require 'win32api4ruby/base'

module Win32api4ruby
class Gdi < Base
  extend FFI::Library
  ffi_lib 'gdi32'
  ffi_convention :stdcall


  R2_BLACK = 1   #  0
  R2_NOTMERGEPEN = 2   # DPon
  R2_MASKNOTPEN = 3   # DPna
  R2_NOTCOPYPEN = 4   # PN
  R2_MASKPENNOT = 5   # PDna
  R2_NOT = 6   # Dn
  R2_XORPEN = 7   # DPx
  R2_NOTMASKPEN = 8   # DPan
  R2_MASKPEN = 9   # DPa
  R2_NOTXORPEN = 10  # DPxn
  R2_NOP = 11  # D
  R2_MERGENOTPEN = 12  # DPno
  R2_COPYPEN = 13  # P
  R2_MERGEPENNOT = 14  # PDno
  R2_MERGEPEN = 15  # DPo
  R2_WHITE = 16  #  1
  R2_LAST = 16
  SRCCOPY = 0x00CC0020 # dest = source
  SRCPAINT = 0x00EE0086 # dest = source OR dest
  SRCAND = 0x008800C6 # dest = source AND dest
  SRCINVERT = 0x00660046 # dest = source XOR dest
  SRCERASE = 0x00440328 # dest = source AND (NOT dest )
  NOTSRCCOPY = 0x00330008 # dest = (NOT source)
  NOTSRCERASE = 0x001100A6 # dest = (NOT src) AND (NOT dest)
  MERGECOPY = 0x00C000CA # dest = (source AND pattern)
  MERGEPAINT = 0x00BB0226 # dest = (NOT source) OR dest
  PATCOPY = 0x00F00021 # dest = pattern
  PATPAINT = 0x00FB0A09 # dest = DPSnoo
  PATINVERT = 0x005A0049 # dest = pattern XOR dest
  DSTINVERT = 0x00550009 # dest = (NOT dest)
  BLACKNESS = 0x00000042 # dest = BLACK
  WHITENESS = 0x00FF0062 # dest = WHITE
  #if(WINVER >= 0x0500)
    NOMIRRORBITMAP = 0x80000000 # Do not Mirror the bitmap in this call
    CAPTUREBLT = 0x40000000 # Include layered windows
  #endif # WINVER >= 0x0500

  DIB_RGB_COLORS = 0
  DIB_PAL_COLORS = 1

  BI_RGB = 0
  BI_RLE8 = 1
  BI_RLE4 = 2
  BI_BITFIELDS = 3
  BI_JPEG = 4
  BI_PNG = 5

	PASSTHROUGH = 19
	QUERYESCSUPPORT = 8

	#the functions that wrap the Win32API calls enforce type checking on arguments
  # (through #check). This is to be consistent with the Win32API which will assume
  # different arguments are calling different functions, throwing wacky errors
  #API WRAPPERS

  attach_function :CreateCompatibleBitmap, [ :handle, :int, :int ], :handle
  def self.create_compatible_bitmap(hdc, nWidth, nHeight)
        #~ HBITMAP CreateCompatibleBitmap(
          #~ __in  HDC hdc,
          #~ __in  int nWidth,
          #~ __in  int nHeight
        #~ );
    exception_for_0{
      CreateCompatibleBitmap(hdc, nWidth, nHeight)
    }
  end

  attach_function :CreateBitmap, [ :int, :int, :uint, :uint, :pointer ], :handle
  def self.create_bitmap(nWidth, nHeight, cPlanes, cBitsPerPel, lpvBits)
      #~ HBITMAP CreateBitmap(
        #~ __in  int nWidth,
        #~ __in  int nHeight,
        #~ __in  UINT cPlanes,
        #~ __in  UINT cBitsPerPel,
        #~ __in  const VOID *lpvBits
      #~ );
    exception_for_0{
      CreateBitmap(nWidth, nHeight, cPlanes, cBitsPerPel, lpvBits)
    }
  end

  attach_function :SetDIBits, [ :handle, :handle, :uint, :uint, :pointer, :pointer, :uint ], :int
  def self.set_dibits(hdc, hbmp, uStartScan, cScanLines, lpvBits, lpbmi, fuColorUse)
      #~ int SetDIBits(
        #~ __in  HDC hdc,
        #~ __in  HBITMAP hbmp,
        #~ __in  UINT uStartScan,
        #~ __in  UINT cScanLines,
        #~ __in  const VOID *lpvBits,
        #~ __in  const BITMAPINFO *lpbmi,
        #~ __in  UINT fuColorUse
      #~ );
    exception_for_0{
      SetDIBits(hdc, hbmp, uStartScan, cScanLines, lpvBits, lpbmi, fuColorUse)
    }
  end

  attach_function :SetDIBitsToDevice, [ :handle, :int, :int, :uint, :uint, :int, :int, :uint, :uint, :pointer, :pointer, :uint ], :int
  def self.set_dibits_to_device(hdc, xDest, yDest, dwWidth, dwHeight, xSrc, ySrc, uStartScan, cScanLines, lpvBits, lpbmi, fuColorUse)
    #~ int SetDIBitsToDevice(
      #~ __in  HDC hdc,
      #~ __in  int XDest,
      #~ __in  int YDest,
      #~ __in  DWORD dwWidth,
      #~ __in  DWORD dwHeight,
      #~ __in  int XSrc,
      #~ __in  int YSrc,
      #~ __in  UINT uStartScan,
      #~ __in  UINT cScanLines,
      #~ __in  const VOID *lpvBits,
      #~ __in  const BITMAPINFO *lpbmi,
      #~ __in  UINT fuColorUse
    #~ );
    exception_for_negative{
      SetDIBitsToDevice(hdc, xDest, yDest, dwWidth, dwHeight, xSrc, ySrc, uStartScan, cScanLines, lpvBits, lpbmi, fuColorUse)
    }
  end


  attach_function :BitBlt, [ :handle, :int, :int, :int, :int, :handle, :int, :int, :uint32 ], :int
  def self.bit_blt(hdcDest, nXDest, nYDest, nWidth, nHeight, hdcSrc, nXSrc, nYSrc, dwRop)
      #~ BOOL BitBlt(
        #~ __in  HDC hdcDest,
        #~ __in  int nXDest,
        #~ __in  int nYDest,
        #~ __in  int nWidth,
        #~ __in  int nHeight,
        #~ __in  HDC hdcSrc,
        #~ __in  int nXSrc,
        #~ __in  int nYSrc,
        #~ __in  DWORD dwRop
      #~ );
    exception_for_0{
      BitBlt(hdcDest, nXDest, nYDest, nWidth, nHeight, hdcSrc, nXSrc, nYSrc, dwRop)
    }
  end


  attach_function :TextOutW, [ :handle, :int, :int, :pointer, :int ], :int
  attach_function :TextOutA, [ :handle, :int, :int, :pointer, :int ], :int
  def self.text_out(hdc, nXStart, nYStart, lpString, cbString)
      #~ BOOL TextOut(
        #~ __in  HDC hdc,
        #~ __in  int nXStart,
        #~ __in  int nYStart,
        #~ __in  LPCTSTR lpString,
        #~ __in  int cbString
      #~ );
    exception_for_0{
      args = hdc, nXStart, nYStart, lpString, cbString
      unicode ? TextOutW(*args) : TextOutA(*args)
    }
  end


  attach_function :SelectObject, [ :handle, :handle ], :handle
  def self.select_object(hdc, hgdiobj)
      #~ HGDIOBJ SelectObject(
        #~ HDC hdc,
        #~ HGDIOBJ hgdiobj
      #~ );
    exception_for_0{
      SelectObject(hdc, hgdiobj)
    }
  end


  attach_function :SelectObject, [ :handle, :int, :pointer ], :int
  def self.get_object(hgdiobj, cbBuffer, lpvObject)
      #~ int GetObject(
        #~ __in   HGDIOBJ hgdiobj,
        #~ __in   int cbBuffer,
        #~ __out  LPVOID lpvObject
      #~ );
    exception_for_0{
      GetObject(hgdiobj, cbBuffer, lpvObject)
    }
  end


  attach_function :DeleteDC, [ :handle ], :int
  # nur bei CreateDC verwenden
  def self.delete_dc(hDC)
      #~ BOOL DeleteDC(
        #~ __in  HDC hdc
      #~ );

    exception_for_0{
      DeleteDC(hDC)
    }
  end


  attach_function :DeleteObject, [ :handle ], :int
  # nur bei CreateDC verwenden
  def self.delete_object(hDC)
      #~ BOOL DeleteDC(
        #~ __in  HDC hdc
      #~ );

    exception_for_0{
      DeleteObject(hDC)
    }
  end


  attach_function :CreateCompatibleDC, [ :handle ], :handle
  def self.create_compatible_dc(hdc)
      #~ HDC CreateCompatibleDC(
        #~ __in  HDC hdc
      #~ );
    exception_for_0{
      CreateCompatibleDC(hdc)
    }
  end


  attach_function :CreateDCW, [ :pointer, :pointer, :pointer, :pointer ], :handle
  attach_function :CreateDCA, [ :pointer, :pointer, :pointer, :pointer ], :handle
  def self.create_dc(lpszDriver, lpszDevice, lpszOutput, lpInitData)
       #~ HDC CreateDC(
            #~ LPCTSTR lpszDriver,
      #~ __in  LPCTSTR lpszDevice,
            #~ LPCTSTR lpszOutput,
      #~ __in  const DEVMODE *lpInitData
    #~ );

    #~ hDC = CreateDC( 0, sPrnName, 0, dm );
    exception_for_0{
      args = lpszDriver, lpszDevice, lpszOutput, lpInitData
      unicode ? CreateDCW(*args) : CreateDCA(*args)
    }
  end


  attach_function :AbortDoc, [ :handle ], :int
  def self.abort_doc(hPrinter)
      #~ int AbortDoc(
        #~ __in  HDC hdc
      #~ );
    exception_for_0{
      AbortDoc(hPrinter)
    }
  end


  attach_function :StartDocW, [ :handle, :pointer ], :int
  attach_function :StartDocA, [ :handle, :pointer ], :int
  def self.start_doc(hPrinter, pDocInfo)
    exception_for_0{
      args = hPrinter, pDocInfo
      unicode ? StartDocW(*args) : StartDocA(*args)
    }
  end


  attach_function :EndDoc, [ :handle ], :int
  def self.end_doc(hPrinter)
    exception_for_0{
      EndDoc(hPrinter)
    }
  end


  attach_function :StartPage, [ :handle ], :int
  def self.start_page(hPrinter)
    exception_for_0{
      StartPage(hPrinter)
    }
  end


  attach_function :EndPage, [ :handle ], :int
  def self.end_page(hPrinter)
      #~ int EndPage(
        #~ __in  HDC hdc
      #~ );
    exception_for_0{
      EndPage(hPrinter)
    }
  end


  attach_function :CreateFontW, [ :int, :int, :int, :int, :int, :ulong, :ulong, :ulong, :ulong, :ulong, :ulong, :ulong, :ulong, :pointer ], :handle
  attach_function :CreateFontA, [ :int, :int, :int, :int, :int, :ulong, :ulong, :ulong, :ulong, :ulong, :ulong, :ulong, :ulong, :pointer ], :handle
  def self.create_font(nHeight, nWidth, nEscapement, nOrientation, fnWeight, fdwItalic, fdwUnderline, fdwStrikeOut, fdwCharSet, fdwOutputPrecision, fdwClipPrecision, fdwQuality, fdwPitchAndFamily, lpszFace)
      #~ HFONT CreateFont(
        #~ __in  int nHeight,
        #~ __in  int nWidth,
        #~ __in  int nEscapement,
        #~ __in  int nOrientation,
        #~ __in  int fnWeight,
        #~ __in  DWORD fdwItalic,
        #~ __in  DWORD fdwUnderline,
        #~ __in  DWORD fdwStrikeOut,
        #~ __in  DWORD fdwCharSet,
        #~ __in  DWORD fdwOutputPrecision,
        #~ __in  DWORD fdwClipPrecision,
        #~ __in  DWORD fdwQuality,
        #~ __in  DWORD fdwPitchAndFamily,
        #~ __in  LPCTSTR lpszFace
      #~ );
    exception_for_0{
      args = nHeight, nWidth, nEscapement, nOrientation, fnWeight, fdwItalic, fdwUnderline, fdwStrikeOut, fdwCharSet, fdwOutputPrecision, fdwClipPrecision, fdwQuality, fdwPitchAndFamily, lpszFace
      unicode ? CreateFontW(*args) : CreateFontA(*args)
    }
  end

  attach_function :Escape, [ :handle, :int, :int, :pointer, :pointer ], :int
  def self.escape(hdc, nEscape, lpvInData, lpvOutData)
				#~ int Escape(
				#~ __in   HDC hdc,
				#~ __in   int nEscape,
				#~ __in   int cbInput,
				#~ __in   LPCSTR lpvInData,
				#~ __out  LPVOID lpvOutData
			#~ );
		cbInput = lpvInData.length
    exception_for_0{
      Escape(hdc, nEscape, cbInput, lpvInData, lpvOutData)
    }
  end

  class BITMAPINFOHEADER < FFI::Struct
    # BITMAPINFOHEADER {
    #   DWORD biSize;
    #   LONG  biWidth;
    #   LONG  biHeight;
    #   WORD  biPlanes;
    #   WORD  biBitCount;
    #   DWORD biCompression;
    #   DWORD biSizeImage;
    #   LONG  biXPelsPerMeter;
    #   LONG  biYPelsPerMeter;
    #   DWORD biClrUsed;
    #   DWORD biClrImportant;
    # }
    layout :biSize, :uint32,
      :biWidth, :long,
      :biHeight, :long,
      :biPlanes, :uint16,
      :biBitCount, :uint16,
      :biCompression, :uint32,
      :biSizeImage, :uint32,
      :biXPelsPerMeter, :long,
      :biYPelsPerMeter, :long,
      :biClrUsed, :uint32,
      :biClrImportant, :uint32
  end

  def self.create_BITMAPINFOHEADER(ptrdata=nil, size=nil)
    ptrdata = BITMAPINFOHEADER.new(ptrdata || (size && FFI::MemoryPointer.new(size)))
    ptrdata[:biSize] = ptrdata.size
    return ptrdata
  end

  class DOCINFO < FFI::Struct
      # struct {
      #   int     cbSize;
      #   LPCTSTR lpszDocName;
      #   LPCTSTR lpszOutput;
      #   LPCTSTR lpszDatatype;
      #   DWORD   fwType;
      # } DOCINFO
    layout :cbSize, :int,
      :lpszDocName, :pointer,
      :lpszOutput, :pointer,
      :lpszDatatype, :pointer,
      :fwType, :uint32
  end

  def self.create_DOCINFO(ptrdata=nil, size=nil)
    ptrdata = DOCINFO.new(ptrdata || (size && FFI::MemoryPointer.new(size)))
    ptrdata[:cbSize] = ptrdata.size
    return ptrdata
  end
end
end