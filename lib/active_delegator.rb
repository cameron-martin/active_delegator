require "active_delegator/version"

require 'active_record'

class ActiveDelegator < ActiveRecord::Base

  self.abstract_class=true


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

  def write_attribute(attr, value)
    model_instance.public_send("#{attr}=", value)
    super
  end

  def model_instance
    @model ||= self.class.model_class.allocate
  end

  ## Copies attributes from store to model
  #def set_attributes
  #  self.class.attributes.each do |attr|
  #    model_instance.public_send("#{attr}=", read_attribute(attr))
  #  end
  #end
  #
  ## Copies attributes from model to store
  #def get_attributes
  #  self.class.attributes.each do |attr|
  #    write_attribute(attr, model_instance.public_send(attr))
  #  end
  #end


end
