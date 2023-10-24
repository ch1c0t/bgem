def self.types
  constants = Ext.constants
  constants.delete :StandardHooks
  constants.map &:downcase
end
