require 'rspec'

require 'active_delegator/attribute_proxy'

describe ActiveDelegator::AttributeProxy do

  let(:model) { double('model') }
  let(:attribute_proxy) { ActiveDelegator::AttributeProxy.new(model, { :attr1 => :attr2 }) }

  describe '#[]' do
    it 'delegates mapped attribute getters to model' do
      model.should_receive(:attr2)
      attribute_proxy[:attr1]
    end

    it 'normalises arguments' do
      model.should_receive(:attr2)
      attribute_proxy['attr1']
    end

    it 'persists internal attributes' do
      attribute_proxy[:other] = :value
      expect(attribute_proxy[:other]).to eq(:value)
    end
  end

  describe '#[]=' do
    it 'delegates mapped attribute getters to model' do
      model.should_receive(:attr2=).with(:value)
      attribute_proxy[:attr1] = :value
    end

    it 'normalises arguments' do
      model.should_receive(:attr2=).with(:value)
      attribute_proxy['attr1'] = :value
    end

    it 'handles unmapped attributes internally' do
      attribute_proxy[:other] = :value
    end
  end

  describe '#keys' do
    it 'returns mapped keys' do
      expect(attribute_proxy.keys).to eq([:attr1])
    end
    it 'returns internal keys as well' do
      attribute_proxy[:other] = :value
      expect(attribute_proxy.keys).to eq([:attr1, :other])
    end
  end

  describe '#has_key?' do
    it 'has mapped key' do
      expect(attribute_proxy.has_key?(:attr1)).to be_true
    end
    it 'normalises arguments' do
      expect(attribute_proxy.has_key?('attr1')).to be_true
    end
    it 'does not have other key' do
      expect(attribute_proxy.has_key?(:other)).to be_false
    end
    it 'has unmapped key' do
      attribute_proxy[:other] = :value
      expect(attribute_proxy.has_key?(:other)).to be_true
    end
  end
end