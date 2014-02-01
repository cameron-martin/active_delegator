require 'active_delegator/model_serializer'

module ActiveDelegator
  class Mapper

    class << self

      attr_reader :model_class

      # User options

      def maps_to(klass)
        @model_class = klass
      end

      def attribute(attr)
        attr = {attr => attr} unless attr.is_a?(Hash)
        attribute_map.merge!(attr)
      end

      # Class-level accessors

      def attribute_map
        @attribute_map ||= {}
      end

      def store_class
        @store_class ||= Class.new(ActiveRecord::Base)
      end

      def serializer
        @serializer ||= ModelSerializer.new(attribute_map)
      end

      # Class methods

      # Creates a new record from a model
      # Serializes the model, then creates a new activerecord object from it
      def create(model)
        new(store_class.new(serializer.serialize(model)), model)
      end

      def find(id)
        new(store_class.find(id))
      end

    end

    def initialize(store, model=nil)
      @store = store
      @model = model || create_model
    end

    def create_model
      self.class.serializer.unserialize(self.class.model_class, @store.attributes)
    end

    def model
      return @model unless block_given?
      yield @model
      update
    end

  private

    # Copies over attributes from the model to the store
    def update
      @store.assign_attributes(self.class.serializer.serialize(@model))
    end


  end
end