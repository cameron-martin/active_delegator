require 'rspec'

require 'active_delegator/base'

class TestMapper < ActiveDelegator::Base

end

module ActiveDelegator
  describe Base do

    let(:mapper) { TestMapper }
    let(:store) { double('store') }
    let(:model) { double('model') }

    let(:new_object) { mapper.new(store, model) }


    describe '.serializer' do
      it 'returns a serializer instance' do
        expect(mapper.serializer).to be_a(ModelSerializer)
      end
    end

  end
end
