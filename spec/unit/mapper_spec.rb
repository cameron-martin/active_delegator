require 'rspec'

require 'active_delegator/mapper'

class TestMapper < ActiveDelegator::Mapper

end

module ActiveDelegator
  describe Mapper do

    let(:mapper) { TestMapper }

    let(:new_object) {  }

    describe '.store' do
      it 'returns an activerecord instance' do
        expect(mapper.store).to be_a(ActiveRecord::Base)
      end
    end

    describe '.serializer' do
      it 'returns a serializer instance' do
        expect(mapper.serializer).to be_a(ModelSerializer)
      end
    end

    describe '.create' do
      it 'creates a new activerecord record' do
        expect(new_object.store.new_record).to be_true
      end
    end

    describe '.update' do
      it 'creates a new activerecord record' do
        expect(new_object.store.new_record).to be_true
      end
    end
  end
end
