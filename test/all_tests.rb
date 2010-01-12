require "test/unit"
require "win32api4ruby"

basedir = File.dirname(__FILE__)
Dir[File.join(basedir, 'test_*.rb')].each{|f| load f }
