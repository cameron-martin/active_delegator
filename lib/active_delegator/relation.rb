module ActiveDelegator
  class Relation

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
    end

    def to_a
      @relation.to_a.each_with_object([]) do |arr, store|
        arr << @mapper_class.new(store)
      end
    end

    def each
      @relation.each do |store|
        yield @mapper_class.new(store)
      end
    end
  end
end