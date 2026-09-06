include YAML::Serializable

property command : String
property stdout : String 
property stderr : String 
property exit_code : Int32

def initialize(@command, @stdout, @stderr, @exit_code)
end
