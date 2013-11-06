require "test/unit"
require "win32api4ruby"
require File.join(File.dirname(__FILE__),"base")

module TestComdlg
  include Win32api4ruby

  def test_print_dialog
    # wird zwar gestartet, liefert aber keine gef�llte struktur zur�ck
    pdlg = Comdlg.create_PRINTDLG
    pdlg[:hwndOwner] = 0
    pdlg[:Flags] = Comdlg::PD_RETURNDC | Comdlg::PD_NOSELECTION
    ok = Comdlg.print_dlg(pdlg)

    puts "res: #{ok.to_s(16)}" # pdlg: #{pdlg.values}"
    hDevNames = pdlg[:hDevNames]
    Kernel.with_global_lock(hDevNames){|pDevNames|
      dn_prt = Comdlg.create_DEVNAMES(pDevNames)

      u = Base.unicode ? 2 : 1
      driver = FFI::Pointer.new(pDevNames+dn_prt[:wDriverOffset]*u).to_s_utf8
      device = FFI::Pointer.new(pDevNames+dn_prt[:wDeviceOffset]*u).to_s_utf8
      output = FFI::Pointer.new(pDevNames+dn_prt[:wOutputOffset]*u).to_s_utf8
      default = FFI::Pointer.new(pDevNames+dn_prt[:wDefault]*u).to_s_utf8
      puts "Driver: #{driver.inspect} Device: #{device.inspect} Output: #{output.inspect} Default: #{default.inspect}"
    }
  end
end

define_test_class(TestComdlg)
