require 'active_delegator/model_serializer'
require 'active_delegator/relation'

module ActiveDelegator
  class Base

    class << self

      extend Forwardable

      attr_reader :model_class

      # Relations

      def has_many(*args, &block)
        store_class.has_many(*args, &block)
      end

      def belongs_to(*args, &block)
        store_class.belongs_to(*args, &block)
      end

      def has_one(*args, &block)
        store_class.has_one(*args, &block)
      end

      def table(table_name)
        store_class.table_name=table_name
      end

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

      def_delegators :all, :where

      def all
        Relation.new(store_class.all, self)
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
      self
    end

    def save
      @store.save
    end

    def[](key)
      @store[key]
    end

    def []=(key, value)
      @store[key] = value
      if self.class.attribute_map.has_key?(key.to_sym)
        @model.public_send("#{self.class.attribute_map[key.to_sym]}=", value)
      end
    end

  private

    # Copies over attributes from the model to the store
    def update
      @store.assign_attributes(self.class.serializer.serialize(@model))
    end


  end
end