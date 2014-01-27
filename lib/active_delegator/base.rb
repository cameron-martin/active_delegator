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

      def attributes
        @attributes ||= []
      end


      def attribute(attr)
        attributes.push(attr)
      end

      #def wrap(model)
      #  allocate.tap do |store|
      #    store.model_instance = model
      #    store.init_with('attributes' => store.attribute_proxy)
      #  end
      #end

      def insert(model)
        new.tap do |store|
          store.handle_insert(model)
        end
      end

    end

    attr_writer :model_instance

    after_find do |store|
      store.create_model
    end

    def handle_insert(model)
      self.class.attributes.each do |attr|
        self[attr] = model.public_send(attr)
      end
      self.model_instance = model
      use_attribute_proxy
    end

    def create_model
      @model_instance = self.class.model_class.allocate
      @attributes.each do |key, value|
        attribute_proxy[key]=value
      end
      use_attribute_proxy
    end

    def use_attribute_proxy
      @attributes = attribute_proxy
    end

    def attribute_proxy
      @attribute_proxy ||= AttributeProxy.new(model_instance, self.class.attributes)
    end

    def model_instance
      return @model_instance if instance_variable_defined?(:@model_instance)
      create_model
      @model_instance
    end

    def method_missing(method, *args, &block)
      model_instance.send(method, *args, &block)
    end

    # Copies attributes from store to model
    #def set_attributes
    #  self.class.attributes.each do |attr|
    #    model_instance.public_send("#{attr}=", read_attribute(attr))
    #  end
    #end
    #
    ### Copies attributes from model to store
    #def get_attributes
    #  self.class.attributes.each do |attr|
    #    write_attribute(attr, model_instance.public_send(attr))
    #  end
    #end

  end
end
