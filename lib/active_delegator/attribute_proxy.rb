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

    def has_key?(key)
      @attributes.include?(key.to_sym)
    end

    alias_method :include?, :has_key?
    alias_method :key?, :has_key?

    def each
      return to_enum(:each) unless block_given?
      @attributes.each do |attr|
        yield attr, self[attr]
      end
    end

  end
end