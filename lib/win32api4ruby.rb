# -*- coding: UTF-8 -*-

require 'dl'

module Win32api4ruby
  VERSION = '0.1.1'

  autoload 'Base', 'win32api4ruby/base'
  autoload 'Comdlg', 'win32api4ruby/comdlg'
  autoload 'Gdi', 'win32api4ruby/gdi'
  autoload 'Kernel', 'win32api4ruby/kernel'
  autoload 'User', 'win32api4ruby/user'
  autoload 'Winspool', 'win32api4ruby/winspool'
end
