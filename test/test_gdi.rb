require "test/unit"
require "win32api4ruby"
require File.join(File.dirname(__FILE__),"base")

module TestGdi
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

  def test_create_bitmap
    hwnd = User.create_window_ex(0, 'STATIC'.to_s_win32, 'Name'.to_s_win32, User::WS_VISIBLE, 0,0,600,300, 0, 0, 0)
    hdc = User.get_dc(hwnd)
    lpbmi = Gdi.create_BITMAPINFOHEADER

    xDest, yDest, dwWidth, dwHeight, xSrc, ySrc = 0,0, 60,50, 0,0
    lpvBits = ('z000'+'0z00'+'00z0') * (dwWidth/3) * dwHeight
    uStartScan, cScanLines = 0, dwHeight
    fuColorUse = Gdi::DIB_RGB_COLORS

    lpbmi[:biWidth] = dwWidth
    lpbmi[:biHeight] = dwHeight
    lpbmi[:biPlanes] = 1
    lpbmi[:biBitCount] = 32
    lpbmi[:biCompression] = Gdi::BI_RGB
    lpbmi[:biSizeImage] = lpvBits.length
    lpbmi[:biXPelsPerMeter] = 0
    lpbmi[:biYPelsPerMeter] = 0
    lpbmi[:biClrUsed] = 0
    lpbmi[:biClrImportant] = 0

    Gdi.set_dibits_to_device(hdc, xDest, yDest, dwWidth, dwHeight, xSrc, ySrc, uStartScan, cScanLines, lpvBits, lpbmi, fuColorUse)
  end

	def test_escape
    #~ hPrinter = Win32api4ruby::Gdi.create_dc(nil, "Microsoft XPS Document Writer".to_s_win32, nil, nil)
    hPrinter = Win32api4ruby::Gdi.create_dc(nil, "Zebra P430i Card Printer USB".to_s_win32, nil, nil)

    documentName = "Test Escape"
    docinfo = Win32api4ruby::Gdi.create_DOCINFO
    docinfo[:lpszDocName] = Win32api4ruby::Base.prepare_PtrData(documentName.to_s_win32)
		Gdi.start_doc(hPrinter, docinfo)

		send_escape(hPrinter, "MCL")
		send_escape(hPrinter, "MCI")

		Gdi.end_doc(hPrinter)
		Gdi.delete_dc(hPrinter)
		GC.start
	end

	private

	def send_escape(hPrinter, escape)
		command = ["1B", escape, "0D"].pack("H*a*H*")
		puts("Send #{escape}")
		start = Time.now
		Gdi.escape(hPrinter, Gdi::PASSTHROUGH, [command.length, command].pack('va*'), nil)
#    dur = Time.now - start
#		puts("Time for #{escape}: #{dur}s")
#		puts("Sleep for 5s...")
		sleep(5)
	end

end

define_test_class(TestGdi)