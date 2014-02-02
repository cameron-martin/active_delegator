module ActiveDelegator
  class Relation

    include Enumerable

    class << self

      private
      def delegate(method)
        define_method(method) do |*args, &block|
          self.class.new(@relation.public_send(method, *args, &block), @mapper_class)
        end
      end
    end

    delegate :where

    def initialize(relation, mapper_class)
      @relation = relation
      @mapper_class = mapper_class
      @cache = nil
    end

    def to_a
      (@cache ||= generate_cache).dup
    end


    def each(*args, &block)
      to_a.each(*args, &block)
    end

    private
    def generate_cache
      @relation.to_a.each_with_object([]) do |store, arr|
        arr << @mapper_class.new(store)
      end
    end
  end
end