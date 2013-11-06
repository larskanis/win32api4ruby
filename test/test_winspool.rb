require "test/unit"
require "win32api4ruby"
require File.join(File.dirname(__FILE__),"base")

module TestWinspool
  include Win32api4ruby

  def test_enum_printers
    flags = Winspool::PRINTER_ENUM_NAME
    name = nil
    level = 4
    infos = Winspool.enum_printers(flags, name, level)
    infos[0..1].each{|info|
      puts "PrinterName: #{info[:pPrinterName].to_s_utf8}, ServerName: #{info[:pServerName].to_s_utf8}, Attributes: #{info[:Attributes]}"
    }
  end

  def test_document_properties
    flags = Winspool::PRINTER_ENUM_NAME
    name = nil
    level = 4
    infos = Winspool.enum_printers(flags, name, level)
    info = infos[0]

    if info
      devmod = Winspool.document_properties nil, nil, info[:pPrinterName], nil, Winspool::DM_OUT_BUFFER
      assert devmod.size > 10
      assert_operator 50..10000, :===, devmod[:dmYResolution]
      assert_operator 50..10000, :===, devmod[:dmPrintQuality]
    else
      puts "no printer installed"
    end
  end
end

define_test_class(TestWinspool)
