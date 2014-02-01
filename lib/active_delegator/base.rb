# REVIEW: What to do wrt dirty tracking when an object updates its self.

require 'active_record'

require 'active_delegator/attribute_proxy'

module ActiveDelegator
  class Base < ActiveRecord::Base

    self.abstract_class=true

    #after_initialize do |store|
    #  store.set_attributes
    #end

    class << self

      attr_accessor :model_class

      def maps_to(klass)
        self.model_class = klass
      end

      def attribute_map
        @attribute_map ||= {}
      end

      def attributes
        attribute_map.keys
      end


      def attribute(attr)
        attr = {attr => attr} unless attr.is_a?(Hash)
        attribute_map.merge!(attr)
      end

      def wrap(model)
        new.tap do |store|
          store.use_model(model)
        end
      end

    end

    attr_writer :model_instance

    after_find do |store|
      store.create_model
    end

    def use_model(model)
      self.model_instance = model
      self.class.attributes.each do |attr|
        self[attr] = attribute_proxy[attr]
      end
      use_attribute_proxy
    end

    def create_model
      raise 'Model already created' if instance_variable_defined?(:@model_instance)
      @model_instance = self.class.model_class.allocate
      @attributes.each do |key, value|
        attribute_proxy[key]=value
      end
      use_attribute_proxy
    end

    def model_instance
      return @model_instance if instance_variable_defined?(:@model_instance)
      create_model
      @model_instance
    end

  private

    def use_attribute_proxy
      raise 'Attribute proxy already being used' if @attributes.is_a?(AttributeProxy)
      @attributes = attribute_proxy
    end

    def attribute_proxy
      @attribute_proxy ||= AttributeProxy.new(model_instance, self.class.attribute_map)
    end

    #def method_missing(method, *args, &block)
    #  model_instance.send(method, *args, &block)
    #end
    #
    #def respond_to_missing?(method_name, include_private = false)
    #  model_instance.respond_to?(method_name, include_private) || super
    #end

  end
end
