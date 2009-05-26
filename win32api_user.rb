if __FILE__ == $0
  require 'Win32API'
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
end

if __FILE__ == $0
end
