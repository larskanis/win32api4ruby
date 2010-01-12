require "test/unit"
require "win32api4ruby"

class TestWin32api4ruby < Test::Unit::TestCase
  include Win32api4ruby

  def test_enum_printers
    flags = Winspool::PRINTER_ENUM_NAME
    name = nil
    level = 4
    infos = Winspool.enum_printers(flags, name, level)
    infos.each{|info|
      puts "PrinterName: #{info[:pPrinterName]}, ServerName: #{info[:pServerName]}, Attributes: #{info[:Attributes]}"
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
