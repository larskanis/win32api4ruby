# -*- coding: UTF-8 -*-

require 'win32api4ruby/base'

module Win32api4ruby
class Gdi < Base
  GDI32 = DL.dlopen('gdi32')


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


  #the functions that wrap the Win32API calls enforce type checking on arguments
  # (through #check). This is to be consistent with the Win32API which will assume
  # different arguments are calling different functions, throwing wacky errors
  #API WRAPPERS
  #--------------------------------------------------------------------------------------------------------------
  
  CreateCompatibleBitmap = GDI32['CreateCompatibleBitmap', 'LLL']
  def self.create_compatible_bitmap(hdc, nWidth, nHeight)
        #~ HBITMAP CreateCompatibleBitmap(
          #~ __in  HDC hdc,
          #~ __in  int nWidth,
          #~ __in  int nHeight
        #~ );
    exception_for_0{
      api_call(CreateCompatibleBitmap, hdc, nWidth, nHeight)
    }
  end
  #--------------------------------------------------------------------------------------------------------------
  
  CreateBitmap = GDI32['CreateBitmap', 'LLLLLP']
  def self.create_bitmap(nWidth, nHeight, cPlanes, cBitsPerPel, lpvBits)
      #~ HBITMAP CreateBitmap(
        #~ __in  int nWidth,
        #~ __in  int nHeight,
        #~ __in  UINT cPlanes,
        #~ __in  UINT cBitsPerPel,
        #~ __in  const VOID *lpvBits
      #~ );
    exception_for_0{
      api_call(CreateBitmap, nWidth, nHeight, cPlanes, cBitsPerPel, lpvBits)
    }
  end
  
  SetDIBits = GDI32['SetDIBits', 'IIIIIPPI']
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
      api_call(SetDIBits, hdc, hbmp, uStartScan, cScanLines, lpvBits, lpbmi, fuColorUse)
    }
  end
  
  SetDIBitsToDevice = GDI32['SetDIBitsToDevice', 'I' + 'I'*9 + 'PPI']
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
      api_call(SetDIBitsToDevice, hdc, xDest, yDest, dwWidth, dwHeight, xSrc, ySrc, uStartScan, cScanLines, lpvBits, lpbmi, fuColorUse)
    }
  end
  #--------------------------------------------------------------------------------------------------------------
  
  BitBlt = GDI32['BitBlt', 'L'*10]
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
      api_call(BitBlt, hdcDest, nXDest, nYDest, nWidth, nHeight, hdcSrc, nXSrc, nYSrc, dwRop)
    }
  end
  #--------------------------------------------------------------------------------------------------------------
  
  TextOutW = GDI32['TextOutW', 'LLLLPL']
  TextOutA = GDI32['TextOutA', 'LLLLPL']
  def self.text_out(hdc, nXStart, nYStart, lpString, cbString)
      #~ BOOL TextOut(
        #~ __in  HDC hdc,
        #~ __in  int nXStart,
        #~ __in  int nYStart,
        #~ __in  LPCTSTR lpString,
        #~ __in  int cbString
      #~ );
    exception_for_0{
      api_call(unicode ? TextOutW : TextOutA, hdc, nXStart, nYStart, lpString, cbString)
    }
  end
  #--------------------------------------------------------------------------------------------------------------
  
  SelectObject = GDI32['SelectObject', 'LLL']
  def self.select_object(hdc, hgdiobj)
      #~ HGDIOBJ SelectObject(
        #~ HDC hdc, 
        #~ HGDIOBJ hgdiobj
      #~ ); 
    #~ check(hMovableMemory,Integer)
    exception_for_0{
      api_call(SelectObject, hdc, hgdiobj)
    }
  end
  #--------------------------------------------------------------------------------------------------------------
  
  GetObject = GDI32['GetObject', 'LLLp']
  def self.get_object(hgdiobj, cbBuffer, lpvObject)
      #~ int GetObject(
        #~ __in   HGDIOBJ hgdiobj,
        #~ __in   int cbBuffer,
        #~ __out  LPVOID lpvObject
      #~ );
    #~ check(hMovableMemory,Integer)
    exception_for_0{
      api_call(GetObject, hgdiobj, cbBuffer, lpvObject)
    }
  end
  #--------------------------------------------------------------------------------------------------------------

  DeleteDC = GDI32['DeleteDC', 'LL']
  # nur bei CreateDC verwenden
  def self.delete_dc(hDC)
      #~ BOOL DeleteDC(
        #~ __in  HDC hdc
      #~ );

    exception_for_0{
      api_call(DeleteDC, hDC)
    }
  end
  #--------------------------------------------------------------------------------------------------------------
  
  DeleteObject = GDI32['DeleteObject', 'LL']
  # nur bei CreateDC verwenden
  def self.delete_object(hDC)
      #~ BOOL DeleteDC(
        #~ __in  HDC hdc
      #~ );

    exception_for_0{
      api_call(DeleteObject, hDC)
    }
  end
  #--------------------------------------------------------------------------------------------------------------
  
  CreateCompatibleDC = GDI32['CreateCompatibleDC', 'LL']
  def self.create_compatible_dc(hdc)
      #~ HDC CreateCompatibleDC(
        #~ __in  HDC hdc
      #~ );
    #~ check(hMovableMemory,Integer)
    exception_for_0{
      api_call(CreateCompatibleDC, hdc)
    }
  end
  #--------------------------------------------------------------------------------------------------------------
  
  CreateDCW = GDI32['CreateDCW', 'LPPPP']
  CreateDCA = GDI32['CreateDCA', 'LPPPP']
  def self.create_dc(lpszDriver, lpszDevice, lpszOutput, lpInitData)
       #~ HDC CreateDC(
            #~ LPCTSTR lpszDriver,
      #~ __in  LPCTSTR lpszDevice,
            #~ LPCTSTR lpszOutput,
      #~ __in  const DEVMODE *lpInitData
    #~ );

    #~ hDC = CreateDC( 0, sPrnName, 0, dm );
    exception_for_0{
      api_call(unicode ? CreateDCW : CreateDCA, lpszDriver, lpszDevice, lpszOutput, lpInitData)
    }
  end
  #--------------------------------------------------------------------------------------------------------------
  
  AbortDoc = GDI32['AbortDoc', 'LL']
  def self.abort_doc(hPrinter)
      #~ int AbortDoc(
        #~ __in  HDC hdc
      #~ );
    check(hPrinter, Integer)
    exception_for_0{
      api_call(AbortDoc, hPrinter)
    }
  end
  #--------------------------------------------------------------------------------------------------------------
  
  StartDocW = GDI32['StartDocW', 'LLP']
  StartDocA = GDI32['StartDocA', 'LLP']
  def self.start_doc(hPrinter, pDocInfo)
    check(hPrinter, Integer)
    exception_for_0{
      api_call(unicode ? StartDocW : StartDocA, hPrinter, pDocInfo)
    }
  end
  #--------------------------------------------------------------------------------------------------------------
  
  EndDoc = GDI32['EndDoc', 'LL']
  def self.end_doc(hPrinter)
    check(hPrinter, Integer)
    exception_for_0{
      api_call(EndDoc, hPrinter)
    }
  end
  #--------------------------------------------------------------------------------------------------------------
  
  StartPage = GDI32['StartPage', 'LL']
  def self.start_page(hPrinter)
    check(hPrinter, Integer)
    exception_for_0{
      api_call(StartPage, hPrinter)
    }
  end
  #--------------------------------------------------------------------------------------------------------------
  
  EndPage = GDI32['EndPage', 'LL']
  def self.end_page(hPrinter)
      #~ int EndPage(
        #~ __in  HDC hdc
      #~ );
    check(hPrinter, Integer)
    exception_for_0{
      api_call(EndPage, hPrinter)
    }
  end
  #--------------------------------------------------------------------------------------------------------------
  
  CreateFontW = GDI32['CreateFontW', 'LLLLLLLLLLLLLLP']
  CreateFontA = GDI32['CreateFontA', 'LLLLLLLLLLLLLLP']
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
    #~ check(hPrinter, Integer)
    exception_for_0{
      api_call(unicode ? CreateFontW : CreateFontA, nHeight, nWidth, nEscapement, nOrientation, fnWeight, fdwItalic, fdwUnderline, fdwStrikeOut, fdwCharSet, fdwOutputPrecision, fdwClipPrecision, fdwQuality, fdwPitchAndFamily, lpszFace)
    }
  end
  
  
  
  BITMAPINFOHEADER_types = 'ILLHHIILLII'
  def self.create_BITMAPINFOHEADER(ptrdata=nil, size=nil)
    ptrdata = prepare_PtrData(ptrdata, size || DL.sizeof(BITMAPINFOHEADER_types))
    ptrdata.struct!(BITMAPINFOHEADER_types, 
      :biSize,
      :biWidth,
      :biHeight,
      :biPlanes,
      :biBitCount,
      :biCompression,
      :biSizeImage,
      :biXPelsPerMeter,
      :biYPelsPerMeter,
      :biClrUsed,
      :biClrImportant)
    ptrdata[:biSize] = ptrdata.size
    return ptrdata
  end

  DOCINFO_types = 'IPPPL'
  def self.create_DOCINFO(ptrdata=nil, size=nil)
    ptrdata = prepare_PtrData(ptrdata, size || DL.sizeof(DOCINFO_types))
    ptrdata.struct!(DOCINFO_types, 
      :cbSize,
      :lpszDocName,
      :lpszOutput,
      :lpszDatatype,
      :fwType)
    ptrdata[:cbSize] = ptrdata.size
    return ptrdata
  end
end
end
