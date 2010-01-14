require "test/unit"
require "win32api4ruby"
require "../test/base"

module TestComdlg
  include Win32api4ruby

  def test_print_dialog
    # wird zwar gestartet, liefert aber keine gef�llte struktur zur�ck
    pdlg = Comdlg.create_PRINTDLG
    pdlg[:hwndOwner] = 0
    pdlg[:Flags] = Comdlg::PD_RETURNDC | Comdlg::PD_NOSELECTION
    ok = Comdlg.print_dlg(pdlg)

    puts "res: #{ok.to_s(16)} pdlg: #{pdlg.inspect}"
    hDevNames = pdlg[:hDevNames]
    Kernel.with_global_lock(hDevNames){|pDevNames|
      dn_prt = DL::PtrData.new(pDevNames, DL.sizeof('H'*4))
      dn_prt.struct!('H'*4,
            :wDriverOffset,
            :wDeviceOffset,
            :wOutputOffset,
            :wDefault)

      u = Base.unicode ? 2 : 1
      driver = DL::PtrData.new(pDevNames+dn_prt[:wDriverOffset]*u).to_s_utf8
      device = DL::PtrData.new(pDevNames+dn_prt[:wDeviceOffset]*u).to_s_utf8
      output = DL::PtrData.new(pDevNames+dn_prt[:wOutputOffset]*u).to_s_utf8
      default = DL::PtrData.new(pDevNames+dn_prt[:wDefault]*u).to_s_utf8
      puts "Driver: #{driver} Device: #{device} Output: #{output} Default: #{default}"
    }
  end
end

define_test_class(TestComdlg)
