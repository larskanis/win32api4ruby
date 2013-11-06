# -*- coding: UTF-8 -*-

require 'win32api4ruby/base'


module Win32api4ruby
class User < Base
  extend FFI::Library
  ffi_lib 'user32'
  ffi_convention :stdcall

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
  attach_function :LoadImageW, [ :handle, :pointer, :uint, :int, :int, :uint ], :handle
  attach_function :LoadImageA, [ :handle, :pointer, :uint, :int, :int, :uint ], :handle
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
      args = hinst, lpszName, uType, cxDesired, cyDesired, fuLoad
      unicode ? LoadImageW(*args) : LoadImageA(*args)
    }
  end
  #--------------------------------------------------------------------------------------------------------------

  attach_function :DrawTextW, [ :handle, :pointer, :int, :pointer, :uint ], :int
  attach_function :DrawTextA, [ :handle, :pointer, :int, :pointer, :uint ], :int
  def self.draw_text(hdc, lpchText, nCount, lpRect, uFormat)
      #~ int DrawText(
        #~ __in     HDC hDC,
        #~ __inout  LPCTSTR lpchText,
        #~ __in     int nCount,
        #~ __inout  LPRECT lpRect,
        #~ __in     UINT uFormat
      #~ );
    exception_for_0{
      args = hdc, lpchText, nCount, lpRect, uFormat
      unicode ? DrawTextW(*args) : DrawTextA(*args)
    }
  end
  #--------------------------------------------------------------------------------------------------------------

  attach_function :CallWindowProcW, [ :pointer, :handle, :uint, :int, :int ], :lresult
  attach_function :CallWindowProcA, [ :pointer, :handle, :uint, :int, :int ], :lresult
  def self.call_window_proc(lpPrevWndFunc, hWnd, msg, wParam, lParam)
      #~ LRESULT CallWindowProc(
          #~ WNDPROC lpPrevWndFunc,
          #~ HWND hWnd,
          #~ UINT Msg,
          #~ WPARAM wParam,
          #~ LPARAM lParam
      #~ );
    args = lpPrevWndFunc, hWnd, msg, wParam, lParam
    unicode ? CallWindowProc(*args) : CallWindowProcA(*args)
  end
  #--------------------------------------------------------------------------------------------------------------

  attach_function :SetWindowLongW, [ :handle, :int, :long ], :long
  attach_function :SetWindowLongA, [ :handle, :int, :long ], :long
  def self.set_window_long(hWnd, nIndex, dwNewLong)
      #~ LONG SetWindowLong(
          #~ HWND hWnd,
          #~ int nIndex,
          #~ LONG dwNewLong
      #~ );
    exception_for_nil{
      args = hWnd, nIndex, dwNewLong
      unicode ? SetWindowLongW(*args) : SetWindowLongA(*args)
    }
  end

  attach_function :CreateWindowExW, [ :uint32, :pointer, :pointer, :uint32, :int, :int, :int, :int, :handle, :handle, :handle, :pointer ], :handle
  attach_function :CreateWindowExA, [ :uint32, :pointer, :pointer, :uint32, :int, :int, :int, :int, :handle, :handle, :handle, :pointer ], :handle
  def self.create_window_ex(dwExStyle, lpClassName, lpWindowName, dwStyle, x, y, nWidth, nHeight, hWndParent, hMenu, hInstance, lpParam=nil)
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
      args = dwExStyle, lpClassName, lpWindowName, dwStyle, x, y, nWidth, nHeight, hWndParent, hMenu, hInstance, lpParam
      unicode ? CreateWindowExW(*args) : CreateWindowExA(*args)
    }
  end

  attach_function :UpdateWindow, [ :handle ], :int
  def self.update_window(hwnd)
    exception_for_0{
      UpdateWindow(hwnd)
    }
  end

  attach_function :DestroyWindow, [ :handle ], :int
  def self.destroy_window(hwnd)
    exception_for_0{
      DestroyWindow(hwnd)
    }
  end

  #~ {GetMessage will return True until it gets a WM_OUIT message.
  #~ So this program will keep running untill you Post a Quit Message}
  attach_function :GetMessageW, [ :pointer, :handle, :long, :long ], :int
  attach_function :GetMessageA, [ :pointer, :handle, :long, :long ], :int
  def self.get_message(lpMsg, hWnd, wMsgFilterMin, wMsgFilterMax)
    exception_for_0{
      args = lpMsg, hWnd, wMsgFilterMin, wMsgFilterMax
      unicode ? GetMessageW(*args) : GetMessageA(*args)
    }
  end

  #~ {Translate any WM_KEYDOWN keyboard Msg to a WM_CHAR message}
  attach_function :TranslateMessage, [ :pointer ], :int
  def self.translate_message(msg)
    TranslateMessage(msg)
  end

  #~ {this Sends Msg to the address of the
  #~ "Window Procedure" set in the Resistered
  #~ Window's Class for that window}
  attach_function :DispatchMessageW, [ :pointer ], :lresult
  attach_function :DispatchMessageA, [ :pointer ], :lresult
  def self.dispatch_message(msg)
    unicode ? DispatchMessageW(msg) : DispatchMessageA(msg)
  end

  attach_function :GetDC, [ :handle ], :handle
  def self.get_dc(hWnd)
    exception_for_0{
      GetDC(hWnd)
    }
  end

end
end
