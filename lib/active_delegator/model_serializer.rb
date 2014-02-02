# Converts a model into an attributes hash
module ActiveDelegator
  class ModelSerializer
    def initialize(attribute_map)
      @attribute_map = attribute_map
    end

    def serialize(model)
      @attribute_map.each_with_object({}) do |(from, to), attributes|
        attributes[from.to_s] = model.public_send(to)
      end
    end

    def unserialize(model, attributes)
      @attribute_map.each do |from, to|
        model.public_send("#{to}=", attributes[from.to_s]) if attributes[from.to_s]
      end
    end
  end
end