= win32api4ruby

* http://comdb1/projektverwaltung/projects/win32api4ruby

== DESCRIPTION:

Yet another win32 to ruby wrapper

== FEATURES:

* printing functions
* error handling
* both Unicode and ANSI-functions supported
* helpers for UTF-8

== PROBLEMS:

* not compatible to win32-gems for Ruby
* only a small subset of DLL-functions implemented

== SYNOPSIS:

short exsample:

  require "win32api4ruby"
  Win32api4ruby::Base.unicode = true
  hwnd = Win32api4ruby::User.create_window_ex(0, 'Button'.to_s_win32, name, User::WS_VISIBLE, 0,0,100,100, 0, 0, 0, 0)


== REQUIREMENTS:

* based on FFI

== INSTALL:

* download win32api4ruby-X.Y.Z.gem
* gem install -l win32api4ruby

== LICENSE:

(The MIT License)

Copyright (c) 2009 FIX

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
