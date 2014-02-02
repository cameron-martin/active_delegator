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

      # REVIEW: This is inconsistent in whether the model is re-created or injected
      def create_or_find(model)
        model_exists?(model) ? find_model(model) : create(model)
      end

      def create_unless_exists(model)
        unless exists?(model)
          create(model).tap do |mapper|
            yield mapper if block_given?
          end.save
        end
      end

      def find(id)
        new(store_class.find(id))
      end

      def exists?(id)
        store_class.exists?(id)
      end

      def find_model(model)
        attributes = serializer.serialize(model)
        id = attributes[store_class.primary_key]
        find(id)
      end

      def model_exists?(model)
        attributes = serializer.serialize(model)
        id = attributes[store_class.primary_key]
        exists?(id)
      end

      def_delegators :all, :where

      def all
        Relation.new(store_class.all, self)
      end

    end

    def initialize(store=nil, model=nil)
      @store = store || self.class.store_class.new
      @model = model || create_model
    end

    def model
      return @model unless block_given?
      yield @model
      sync_from_model
      self
    end

    def save
      sync_from_model
      @store.save
      sync_from_store
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

    def create_model
      self.class.serializer.unserialize(self.class.model_class.allocate, @store.attributes)
    end

    # Copies over attributes from the model to the store
    def sync_from_model
      @store.assign_attributes(self.class.serializer.serialize(@model))
    end

    def sync_from_store
      self.class.serializer.unserialize(@model, @store.attributes)
    end


  end
end