# Converts a model into an attributes hash
module ActiveDelegator
  class ModelSerializer
    def initialize(attribute_map)
      @attribute_map = attribute_map
    end

    def serialize(model)
      @attribute_map.each_with_object({}) do |(from, to), attributes|
        attributes[from] = model.public_send(to)
      end
    end

    def unserialize(klass, attributes)
      klass.allocate.tap do |model|
        @attribute_map.each do |from, to|
          model.public_send("#{to}=", attributes[from]) if attributes[from]
        end
      end
    end
  end
end