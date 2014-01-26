module ActiveDelegator
  class AttributeProxy
    def initialize(model, attributes)
      @attributes = attributes
      @model = model
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

    def each
      return to_enum(:each) unless block_given?
      @attributes.each do |attr|
        yield attr, self[attr]
      end
    end

  end
end