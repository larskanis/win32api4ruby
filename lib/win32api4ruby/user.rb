# -*- coding: UTF-8 -*-

require 'win32api4ruby/base'


module Win32api4ruby
class User < Base
  USER32 = DL.dlopen('user32')

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

  WS_VISIBLE = 0x10000000

  #the functions that wrap the Win32API calls enforce type checking on arguments
  # (through #check). This is to be consistent with the Win32API which will assume
  # different arguments are calling different functions, throwing wacky errors
  #API WRAPPERS
  # --------------------------------------------------------------------------------------------------------------
  LoadImageW = USER32['LoadImageW', 'LLPLLLL']
  LoadImageA = USER32['LoadImageA', 'LLPLLLL']
  def self.load_image(hinst, lpszName, uType, cxDesired, cyDesired, fuLoad)
      #~ HANDLE LoadImage(      
          #~ HINSTANCE hinst,
          #~ LPCTSTR lpszName,
          #~ UINT uType,
          #~ int cxDesired,
          #~ int cyDesired,
          #~ UINT fuLoad
      #~ );
    exception_for_0{
      api_call(unicode ? LoadImageW : LoadImageA, hinst, lpszName, uType, cxDesired, cyDesired, fuLoad)
    }
  end
  #--------------------------------------------------------------------------------------------------------------
  
  DrawTextW = USER32['DrawTextW', 'LLpLpL']
  DrawTextA = USER32['DrawTextA', 'LLpLpL']
  def self.draw_text(hdc, lpchText, nCount, lpRect, uFormat)
      #~ int DrawText(
        #~ __in     HDC hDC,
        #~ __inout  LPCTSTR lpchText,
        #~ __in     int nCount,
        #~ __inout  LPRECT lpRect,
        #~ __in     UINT uFormat
      #~ );
    exception_for_0{
      api_call(unicode ? DrawTextW : DrawTextA, hdc, lpchText, nCount, lpRect, uFormat)
    }
  end
  #--------------------------------------------------------------------------------------------------------------
  
  CallWindowProcW = USER32['CallWindowProcW', 'LPLLLL']
  CallWindowProcA = USER32['CallWindowProcA', 'LPLLLL']
  def self.call_window_proc(lpPrevWndFunc, hWnd, msg, wParam, lParam)
      #~ LRESULT CallWindowProc(      
          #~ WNDPROC lpPrevWndFunc,
          #~ HWND hWnd,
          #~ UINT Msg,
          #~ WPARAM wParam,
          #~ LPARAM lParam
      #~ );
    api_call(unicode ? CallWindowProc : CallWindowProcA, lpPrevWndFunc, hWnd, msg, wParam, lParam)
  end
  #--------------------------------------------------------------------------------------------------------------
  
  SetWindowLongW = USER32['SetWindowLongW', 'PLLP']
  SetWindowLongA = USER32['SetWindowLongA', 'PLLP']
  def self.set_window_long(hWnd, nIndex, dwNewLong)
      #~ LONG SetWindowLong(      
          #~ HWND hWnd,
          #~ int nIndex,
          #~ LONG dwNewLong
      #~ );
    exception_for_nil{
      api_call(unicode ? SetWindowLongW : SetWindowLongA, hWnd, nIndex, dwNewLong)
    }
  end
  
  CreateWindowExW = USER32['CreateWindowExW', 'LLSSLIIIILLLL']
  CreateWindowExA = USER32['CreateWindowExA', 'LLSSLIIIILLLL']
  def self.create_window_ex(dwExStyle, lpClassName, lpWindowName, dwStyle, x, y, nWidth, nHeight, hWndParent, hMenu, hInstance, lpParam)
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
      api_call(unicode ? CreateWindowExW : CreateWindowExA, dwExStyle, lpClassName, lpWindowName, dwStyle, x, y, nWidth, nHeight, hWndParent, hMenu, hInstance, lpParam)
    }
  end
  
  UpdateWindow = USER32['UpdateWindow', 'LL']
  def self.update_window(hwnd)
    exception_for_0{
      api_call(UpdateWindow, hwnd)
    }
  end

  DestroyWindow = USER32['DestroyWindow', 'LL']
  def self.destroy_window(hwnd)
    exception_for_0{
      api_call(DestroyWindow, hwnd)
    }
  end

  #~ {GetMessage will return True until it gets a WM_OUIT message.
  #~ So this program will keep running untill you Post a Quit Message}
  GetMessageW = USER32['GetMessageW', 'LpLLL']
  GetMessageA = USER32['GetMessageA', 'LpLLL']
  def self.get_message(lpMsg, hWnd, wMsgFilterMin, wMsgFilterMax)
    exception_for_0{
      api_call(unicode ? GetMessageW : GetMessageA, lpMsg, hWnd, wMsgFilterMin, wMsgFilterMax)
    }
  end
       
  #~ {Translate any WM_KEYDOWN keyboard Msg to a WM_CHAR message} 
  TranslateMessage = USER32['TranslateMessage', 'LP']
  def self.translate_message(msg)
    api_call(TranslateMessage, msg)
  end
                               
  #~ {this Sends Msg to the address of the 
  #~ "Window Procedure" set in the Resistered
  #~ Window's Class for that window}
  DispatchMessageW = USER32['DispatchMessageW', 'LP']
  DispatchMessageA = USER32['DispatchMessageA', 'LP']
  def self.dispatch_message(msg)
    api_call(unicode ? DispatchMessageW : DispatchMessageA, msg)
  end
  
  GetDC = USER32['GetDC', 'II']
  def self.get_dc(hWnd)
    exception_for_0{
      api_call(GetDC, hWnd)
    }
  end

end
end
