require 'win32api_base'


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


class Win32ApiGDI < Win32ApiBase
  GDI32 = DL.dlopen('gdi32')
  
  #the functions that wrap the Win32API calls enforce type checking on arguments
  # (through #check). This is to be consistent with the Win32API which will assume
  # different arguments are calling different functions, throwing wacky errors
  #API WRAPPERS
  # --------------------------------------------------------------------------------------------------------------
  @@CreateCompatibleBitmap = GDI32['CreateCompatibleBitmap', 'LLL']
  def create_compatible_bitmap(hdc, nWidth, nHeight)
        #~ HBITMAP CreateCompatibleBitmap(
          #~ __in  HDC hdc,
          #~ __in  int nWidth,
          #~ __in  int nHeight
        #~ );
    exception_for_0{
      api_call(@@CreateCompatibleBitmap, hdc, nWidth, nHeight)
    }
  end
  # --------------------------------------------------------------------------------------------------------------
  @@CreateBitmap = GDI32['CreateBitmap', 'LLLLLP']
  def create_bitmap(nWidth, nHeight, cPlanes, cBitsPerPel, lpvBits)
      #~ HBITMAP CreateBitmap(
        #~ __in  int nWidth,
        #~ __in  int nHeight,
        #~ __in  UINT cPlanes,
        #~ __in  UINT cBitsPerPel,
        #~ __in  const VOID *lpvBits
      #~ );
    exception_for_0{
      api_call(@@CreateBitmap, nWidth, nHeight, cPlanes, cBitsPerPel, lpvBits)
    }
  end
  # --------------------------------------------------------------------------------------------------------------
  @@BitBlt = GDI32['BitBlt', 'L'*10]
  def bit_blt(hdcDest, nXDest, nYDest, nWidth, nHeight, hdcSrc, nXSrc, nYSrc, dwRop)
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
      api_call(@@BitBlt, hdcDest, nXDest, nYDest, nWidth, nHeight, hdcSrc, nXSrc, nYSrc, dwRop)
    }
  end
  # --------------------------------------------------------------------------------------------------------------
  @@TextOut = GDI32['TextOut', 'LLLLPL']
  def text_out(hdc, nXStart, nYStart, lpString, cbString)
      #~ BOOL TextOut(
        #~ __in  HDC hdc,
        #~ __in  int nXStart,
        #~ __in  int nYStart,
        #~ __in  LPCTSTR lpString,
        #~ __in  int cbString
      #~ );
    exception_for_0{
      api_call(@@TextOut, hdc, nXStart, nYStart, lpString, cbString)
    }
  end
  # --------------------------------------------------------------------------------------------------------------
  @@SelectObject = GDI32['SelectObject', 'LLL']
  def select_object(hdc, hgdiobj)
      #~ HGDIOBJ SelectObject(
        #~ HDC hdc, 
        #~ HGDIOBJ hgdiobj
      #~ ); 
    #~ check(hMovableMemory,Integer)
    exception_for_0{
      api_call(@@SelectObject, hdc, hgdiobj)
    }
  end
  # --------------------------------------------------------------------------------------------------------------
  @@GetObject = GDI32['GetObject', 'LLLp']
  def get_object(hgdiobj, cbBuffer, lpvObject)
      #~ int GetObject(
        #~ __in   HGDIOBJ hgdiobj,
        #~ __in   int cbBuffer,
        #~ __out  LPVOID lpvObject
      #~ );
    #~ check(hMovableMemory,Integer)
    exception_for_0{
      api_call(@@GetObject, hgdiobj, cbBuffer, lpvObject)
    }
  end
  # --------------------------------------------------------------------------------------------------------------
  @@DeleteDC = GDI32['DeleteDC', 'LL']
  # nur bei CreateDC verwenden
  def delete_dc(hDC)
      #~ BOOL DeleteDC(
        #~ __in  HDC hdc
      #~ );

    exception_for_0{
      api_call(@@DeleteDC, hDC)
    }
  end
  # --------------------------------------------------------------------------------------------------------------
  @@CreateCompatibleDC = GDI32['CreateCompatibleDC', 'LL']
  def create_compatible_dc(hdc)
      #~ HDC CreateCompatibleDC(
        #~ __in  HDC hdc
      #~ );
    #~ check(hMovableMemory,Integer)
    exception_for_0{
      api_call(@@CreateCompatibleDC, hdc)
    }
  end
  # --------------------------------------------------------------------------------------------------------------
  #~ @@CreateDC = Win32API.new('gdi32', 'CreateDC', ['P','P', 'P', 'P'], 'N')
  @@CreateDC = GDI32['CreateDC', 'LPPPP']
  def create_dc(lpszDriver, lpszDevice, lpszOutput, lpInitData)
       #~ HDC CreateDC(
            #~ LPCTSTR lpszDriver,
      #~ __in  LPCTSTR lpszDevice,
            #~ LPCTSTR lpszOutput,
      #~ __in  const DEVMODE *lpInitData
    #~ );

    #~ hDC = CreateDC( 0, sPrnName, 0, dm );
    exception_for_0{
      api_call(@@CreateDC, lpszDriver, lpszDevice, lpszOutput, lpInitData)
    }
  end
  # --------------------------------------------------------------------------------------------------------------
  @@StartDoc = Win32API.new('gdi32', 'StartDoc', ['N','P'], 'N')
  #~ @@StartDoc = GDI32['StartDoc', 'LLP']
  def start_doc(hPrinter, pDocInfo)
    check(hPrinter, Integer); check(pDocInfo, String)
    exception_for_0{
      api_call(@@StartDoc, hPrinter, pDocInfo)
    }
  end
  # --------------------------------------------------------------------------------------------------------------
  @@EndDoc = Win32API.new('gdi32', 'EndDoc', ['N'], 'N')
  #~ @@EndDoc = GDI32['EndDoc', 'LL']
  def end_doc(hPrinter)
    check(hPrinter, Integer)
    exception_for_0{
      api_call(@@EndDoc, hPrinter)
    }
  end
  # --------------------------------------------------------------------------------------------------------------
  @@StartPage = Win32API.new('gdi32', 'StartPage', ['N'],  'N')
  #~ @@StartPage = GDI32['StartPage', 'LL']
  def start_page(hPrinter)
    check(hPrinter, Integer)
    exception_for_0{
      api_call(@@StartPage, hPrinter)
    }
  end
  # --------------------------------------------------------------------------------------------------------------
  @@EndPage = Win32API.new('gdi32', 'EndPage', ['N'], 'N')
  #~ @@EndPage = GDI32['EndPage', 'LL']
  def end_page(hPrinter)
      #~ int EndPage(
        #~ __in  HDC hdc
      #~ );
    check(hPrinter, Integer)
    exception_for_0{
      api_call(@@EndPage, hPrinter)
    }
  end
end

if __FILE__ == $0
  Win32ApiGDI.new
end
