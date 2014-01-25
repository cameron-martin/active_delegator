module ActiveDelegator
  class AttributeProxy
    def initialize(model, start_attributes)
      @attributes = start_attributes.keys
      @model = model

      start_attributes.each do |key, value|
        self[key]=value
      end
    end

    def [](key)
      @model.public_send(key)
    end

    def []=(key, value)
      @model.public_send("#{key}=", value)
    end

    def keys
      @attributes
    end
  end
end