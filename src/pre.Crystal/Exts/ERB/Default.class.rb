include ERB

class Context
  def env
    binding
  end
end

def to_s
  require 'erb'

  env = Context.new.env
  params.each do |name, value|
    env.local_variable_set name, value
  end

  renderer = ::ERB.new code
  code = renderer.result env

  crystal code
end

def crystal code
  type = 'module' if type == 'default'
  cr = Bgem::Output::Ext.new file_extension: 'cr', type: type, name: name, dir: dir, code: code, params: params
  cr.to_s
end
