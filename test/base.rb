
def define_test_class(modul)
  Class.instance_eval <<-EOT
    class TestAnsi#{modul} < Test::Unit::TestCase
      include #{modul}
      def setup
        Win32api4ruby::Base.unicode = false
      end
    end
    class TestUnicode#{modul} < Test::Unit::TestCase
      include #{modul}
      def setup
        Win32api4ruby::Base.unicode = true
      end
    end
  EOT
end
