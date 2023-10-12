def initialize dir:, source:, chain:
  @source = source
  @name = chain.first
end

def to_s
  <<~S
    module #{@name}
      class Context
        def env
          binding
        end
      end

      def self.[] params
        env = Context.new.env
        params.each do |name, value|
          env.local_variable_set name, value
        end

        template = <<~TEMPLATE
          #{@source}TEMPLATE

        require 'erb'
        renderer = ERB.new template
        renderer.result env
      end
    end
  S
end
