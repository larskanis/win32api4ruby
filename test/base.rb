
def define_test_class(modul)
  Class.instance_eval <<-EOT
    class TestAnsi#{modul} < Test::Unit::TestCase
      include #{modul}
      def initialize(*args)
        Win32api4ruby::Base.unicode = false
        super
      end
    end
    class TestUnicode#{modul} < Test::Unit::TestCase
      include #{modul}
      def initialize(*args)
        Win32api4ruby::Base.unicode = true
        super
      end
    end
  EOT
end
