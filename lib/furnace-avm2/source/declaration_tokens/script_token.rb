module Furnace::AVM2::Tokens
  class ScriptToken < Furnace::Code::NonterminalToken
    include TokenWithTraits

    def initialize(origin, options={})
      options = options.merge(environment: :script, global_context: origin)

      global_code = Furnace::AVM2::Decompiler.new(origin.initializer_body,
              options.merge(global_code: true)).decompile

      super(origin, [
        *transform_traits(origin, options.merge(static: false)),
        (global_code if global_code.children.any?)
      ], options)
    end
  end
end