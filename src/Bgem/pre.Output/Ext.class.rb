def self.types
  constants = Ext.constants
  constants.delete :StandardHooks
  constants.map &:downcase
end

def self.new file_extension:, dir:, code:, chain:
  parent_constant = Ext.const_get file_extension.upcase
  name, type = chain

  type ||= if parent_constant.respond_to? :default
             parent_constant.default
           else
             'default'
           end
  constant_name = type.capitalize

  if parent_constant.const_defined? constant_name
    child_constant = parent_constant.const_get constant_name
  else
    fail "Don't know what to do with '#{type}'. #{parent_constant}::#{constant_name} is not defined."
  end

  child_constant.new dir: dir, code: code, name: name, type: type
end
