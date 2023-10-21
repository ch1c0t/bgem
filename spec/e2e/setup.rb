require_relative '../helper'

def bgem
  "#{Dir.pwd}/bin/bgem"
end

RSpec.configure do |c|
  c.before :suite do
    @path = Pathname "/tmp/rspec.bgem.#{$$}/e2e"
    @path.mkpath
  end
end
