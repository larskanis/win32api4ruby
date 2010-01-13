require "test/unit"
require "win32api4ruby"

class TestWin32api4ruby < Test::Unit::TestCase
  include Win32api4ruby

  def test_create_font
    nHeight = 0
    nWidth = 0
    nEscapement = 0
    nOrientation = 0
    fnWeight = 400
    fdwItalic = 0
    fdwUnderline = 0
    fdwStrikeOut = 0
    fdwCharSet = 0
    fdwOutputPrecision = 0
    fdwClipPrecision = 0
    fdwQuality = 0
    fdwPitchAndFamily = 0
    lpszFace = "Arial".to_s_win32

    font = Gdi.create_font(nHeight, nWidth, nEscapement, nOrientation, fnWeight, fdwItalic, fdwUnderline, fdwStrikeOut, fdwCharSet, fdwOutputPrecision, fdwClipPrecision, fdwQuality, fdwPitchAndFamily, lpszFace)

    assert font!=0
  end
end

Win32api4ruby::Base.unicode = false
Test::Unit::AutoRunner.run
Win32api4ruby::Base.unicode = true
Test::Unit::AutoRunner.run
