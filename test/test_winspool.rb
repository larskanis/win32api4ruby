require "test/unit"
require "win32api4ruby"

class TestWin32api4ruby < Test::Unit::TestCase
  include Win32api4ruby

  def test_enum_printers
    flags = Winspool::PRINTER_ENUM_NAME
    name = nil
    level = 4
    infos = Winspool.enum_printers(flags, name, level)
    infos[0..1].each{|info|
      puts "PrinterName: #{info[:pPrinterName].to_s_utf8 if info[:pPrinterName]}, ServerName: #{info[:pServerName].to_s_utf8 if info[:pServerName]}, Attributes: #{info[:Attributes]}"
    }
  end

  def test_document_properties
    flags = Winspool::PRINTER_ENUM_NAME
    name = nil
    level = 4
    infos = Winspool.enum_printers(flags, name, level)
    info = infos[0]

    if info
      devmod = Winspool.document_properties 0, 0, info[:pPrinterName], nil, Winspool::DM_PROMPT|Winspool::DM_OUT_BUFFER
      assert devmod.length > 10
    else

      puts "no printer installed"
    end
  end
end

Win32api4ruby::Base.unicode = false
Test::Unit::AutoRunner.run
Win32api4ruby::Base.unicode = true
Test::Unit::AutoRunner.run
