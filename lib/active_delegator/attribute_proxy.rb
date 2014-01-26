module ActiveDelegator
  class AttributeProxy
    def initialize(model, start_attributes={})
      @attributes = start_attributes.keys
      @model = model

      start_attributes.each do |key, value|
        self[key]=value
      end
    end

    def fetch(key)
      @model.public_send(key)
    end

    alias_method :[], :fetch

    def []=(key, value)
      @model.public_send("#{key}=", value)
    end

    def keys
      @attributes
    end

    def key?(key)
      @model.respond_to?(key)
    end

    alias_method :include?, :key?

  end
end