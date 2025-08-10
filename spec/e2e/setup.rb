require_relative '../helper'

BGEM_DIR = Dir.pwd
BGEM = "#{BGEM_DIR}/bin/bgem"
PATH = Pathname "/tmp/rspec.bgem.#{$$}/e2e"

RSpec.configure do |c|
  c.before :suite do
    PATH.mkpath
  end
end
