module Furnace::AVM2::ABC
  class ScriptInfo < Record
    include InitializerBody
    include RecordWithTraits

    root_ref     :initializer,  :method

    abc_array_of :trait, :nested, :class => TraitInfo

    def collect_ns
      options = { ns: Set.new, no_ns: Set.new, names: {} }
      options[:ns].add package_name.ns if has_name?

      initializer.collect_ns(options) if initializer
      traits.each { |trait| trait.collect_ns(options) }

      options
    end

    def decompile(options={})
      Furnace::AVM2::Tokens::PackageToken.new(self,
            options.merge(collect_ns).merge(
              package_type: :script,
              package_name: package_name)
            )
    end

    def has_name?
      non_init_traits.any?
    end

    def package_name
      non_init_traits[0].name if non_init_traits.any?
    end

    def non_init_traits
      traits.reject { |trait| trait.kind == :Class }
    end
  end
end
