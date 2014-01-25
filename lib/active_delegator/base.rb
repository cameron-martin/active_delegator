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

    end

    attr_accessor :model

    after_initialize do |store|
      store.instance_variable_set(:@attributes, AttributeProxy.new(model_instance, @attributes))
    end
    #
    #def write_attribute(attr, value)
    #  model_instance.public_send("#{attr}=", value)
    #end
    #
    #def read_attribute(attr)
    #  model_instance.public_send(attr)
    #end

    def model_instance
      @model ||= self.class.model_class.allocate
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
