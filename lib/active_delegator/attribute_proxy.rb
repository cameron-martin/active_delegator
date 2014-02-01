# Stands in for the @attributes hash in an active record instance
# It redirects @attributes[:key] to model.key, and @attributes[:key]= to model.key=
# While storing any other keys just as a normal hash does

module ActiveDelegator
  class AttributeProxy
    def initialize(model, attribute_map)
      @attribute_map = attribute_map
      @unmapped_attributes = {}
      @model = model
    end

    def fetch(key)
      key = key.to_sym
      if @attribute_map.has_key?(key)
        @model.public_send(@attribute_map[key])
      else
        @unmapped_attributes[key]
      end
    end

    alias_method :[], :fetch

    def []=(key, value)
      key = key.to_sym
      if @attribute_map.has_key?(key)
        @model.public_send("#{@attribute_map[key]}=", value)
      else
        @unmapped_attributes[key] = value
      end
    end

    def keys
      @attribute_map.keys + @unmapped_attributes.keys
    end

    def has_key?(key)
      keys.include?(key.to_sym)
    end

    alias_method :include?, :has_key?
    alias_method :key?, :has_key?

    def each
      return to_enum(:each) unless block_given?
      keys.each do |attr|
        yield attr, self[attr]
      end
    end

  end
end