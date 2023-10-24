def self.file_extensions
  constants = Ext.constants
  constants.delete :StandardHooks
  constants.map &:downcase
end

def self.new file_extension:, type:, name:, dir:, code:
  parent_constant = Ext.const_get file_extension.upcase

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

  child_constant.new file_extension: file_extension, type: type, name: name, dir: dir, code: code
end
