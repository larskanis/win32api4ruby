# -*- coding: UTF-8 -*-

if __FILE__ == $0
  require 'Win32API'
  require 'win32api_base'
end

IMAGE_ENHMETAFILE = 3
LR_DEFAULTCOLOR = 0x00000000
LR_MONOCHROME = 0x00000001
LR_COLOR = 0x00000002
LR_COPYRETURNORG = 0x00000004
LR_COPYDELETEORG = 0x00000008
LR_LOADFROMFILE = 0x00000010
LR_LOADTRANSPARENT = 0x00000020
LR_DEFAULTSIZE = 0x00000040
LR_VGACOLOR = 0x00000080
LR_LOADMAP3DCOLORS = 0x00001000
LR_CREATEDIBSECTION = 0x00002000
LR_COPYFROMRESOURCE = 0x00004000
LR_SHARED = 0x00008000
#~ #ifdef UNICODE
  #~ LoadImage = LoadImageW
#~ #else
  #~ LoadImage = LoadImageA
#~ #endif # !UNICODE

DI_MASK = 0x0001
DI_IMAGE = 0x0002
DI_NORMAL = 0x0003
DI_COMPAT = 0x0004
DI_DEFAULTSIZE = 0x0008
#if(_WIN32_WINNT >= 0x0501)
  DI_NOMIRROR = 0x0010
#endif /* _WIN32_WINNT >= 0x0501 */

IMAGE_BITMAP = 0
IMAGE_ICON = 1
IMAGE_CURSOR = 2


class Win32ApiUser  < Win32ApiBase
  USER32 = DL.dlopen('user32')
  
  #the functions that wrap the Win32API calls enforce type checking on arguments
  # (through #check). This is to be consistent with the Win32API which will assume
  # different arguments are calling different functions, throwing wacky errors
  #API WRAPPERS
  # --------------------------------------------------------------------------------------------------------------
  #~ @@LoadImage = Win32API.new('user32', 'LoadImage', ['N', 'P', 'N', 'N', 'N', 'N'],  'N')
  @@LoadImage = USER32['LoadImage', 'LLPLLLL']
  def load_image(hinst, lpszName, uType, cxDesired, cyDesired, fuLoad)
      #~ HANDLE LoadImage(      
          #~ HINSTANCE hinst,
          #~ LPCTSTR lpszName,
          #~ UINT uType,
          #~ int cxDesired,
          #~ int cyDesired,
          #~ UINT fuLoad
      #~ );
    exception_for_0{
      api_call(@@LoadImage, hinst, lpszName, uType, cxDesired, cyDesired, fuLoad)
    }
  end
  #--------------------------------------------------------------------------------------------------------------
  
  @@DrawText = USER32['DrawText', 'LLpLpL']
  def draw_text(hdc, lpchText, nCount, lpRect, uFormat)
      #~ int DrawText(
        #~ __in     HDC hDC,
        #~ __inout  LPCTSTR lpchText,
        #~ __in     int nCount,
        #~ __inout  LPRECT lpRect,
        #~ __in     UINT uFormat
      #~ );
    exception_for_0{
      api_call(@@DrawText, hdc, lpchText, nCount, lpRect, uFormat)
    }
  end
  #--------------------------------------------------------------------------------------------------------------
  
  @@CallWindowProc = USER32['CallWindowProc', 'LPLLLL']
  def call_window_proc(lpPrevWndFunc, hWnd, msg, wParam, lParam)
      #~ LRESULT CallWindowProc(      
          #~ WNDPROC lpPrevWndFunc,
          #~ HWND hWnd,
          #~ UINT Msg,
          #~ WPARAM wParam,
          #~ LPARAM lParam
      #~ );
    api_call(@@CallWindowProc, lpPrevWndFunc, hWnd, msg, wParam, lParam)
  end
  #--------------------------------------------------------------------------------------------------------------
  
  @@SetWindowLong = USER32['SetWindowLong', 'PLLP']
  def set_window_long(hWnd, nIndex, dwNewLong)
      #~ LONG SetWindowLong(      
          #~ HWND hWnd,
          #~ int nIndex,
          #~ LONG dwNewLong
      #~ );
    exception_for_nil{
      api_call(@@SetWindowLong, hWnd, nIndex, dwNewLong)
    }
  end
  
  @@CreateWindowExA = USER32['CreateWindowExA', 'LLSSLIIIILLLL']
  def create_window_ex(dwExStyle, lpClassName, lpWindowName, dwStyle, x, y, nWidth, nHeight, hWndParent, hMenu, hInstance, lpParam)
    #~ HWND CreateWindow(      
        #~ DWORD dwExStyle,
        #~ LPCTSTR lpClassName,
        #~ LPCTSTR lpWindowName,
        #~ DWORD dwStyle,
        #~ int x,
        #~ int y,
        #~ int nWidth,
        #~ int nHeight,
        #~ HWND hWndParent,
        #~ HMENU hMenu,
        #~ HINSTANCE hInstance,
        #~ LPVOID lpParam
    #~ );
    exception_for_0{
      api_call(@@CreateWindowExA, dwExStyle, lpClassName, lpWindowName, dwStyle, x, y, nWidth, nHeight, hWndParent, hMenu, hInstance, lpParam)
    }
  end
  
  @@UpdateWindow = USER32['UpdateWindow', 'LL']
  def update_window(hwnd)
    exception_for_0{
      api_call(@@UpdateWindow, hwnd)
    }
  end
  
  #~ {GetMessage will return True until it gets a WM_OUIT message. 
  #~ So this program will keep running untill you Post a Quit Message}
  @@GetMessage = USER32['GetMessage', 'LpLLL']
  def get_message(lpMsg, hWnd, wMsgFilterMin, wMsgFilterMax)
    exception_for_0{
      api_call(@@GetMessage, lpMsg, hWnd, wMsgFilterMin, wMsgFilterMax)
    }
  end
       
  #~ {Translate any WM_KEYDOWN keyboard Msg to a WM_CHAR message} 
  @@TranslateMessage = USER32['TranslateMessage', 'LP']
  def translate_message(msg)
    #~ exception_for_0{
      api_call(@@TranslateMessage, msg)
    #~ }
  end
                               
  #~ {this Sends Msg to the address of the 
  #~ "Window Procedure" set in the Resistered
  #~ Window's Class for that window}
  @@DispatchMessage = USER32['DispatchMessage', 'LP']
  def dispatch_message(msg)
    #~ exception_for_0{
      api_call(@@DispatchMessage, msg)
    #~ }
  end
  

end

if __FILE__ == $0
  Win32ApiUser.new
end
