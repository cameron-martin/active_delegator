require 'rspec'

require 'active_delegator/model_serializer'

module ActiveDelegator
  describe ModelSerializer do

    let(:model_serializer) { ModelSerializer.new({ :db_attr => :model_attr }) }

    describe '#serialize' do

      let(:model) { double('model') }

      it 'should serialize model' do
        model.stub(:model_attr => :name)
        expect(model_serializer.serialize(model)).to eq({:db_attr => :name})
      end
    end

    describe '#unserialize' do
      let(:model) { double('model') }
      context 'without initialize block' do
        let(:model_class) { double('model_class') }
        it 'allocates the model class' do
          model_class.stub(:allocate) { model }
          model_class.should_receive(:allocate)
          model_serializer.unserialize(model_class, {})
        end

        it 'sets model attributes' do
          model_class.stub(:allocate) { model }
          model.should_receive(:model_attr=).with(:value)
          model_serializer.unserialize(model_class, {:db_attr => :value })
        end
      end

      context 'with initialize block' do

        it 'sends new to the model class' do
          model_class.should_receive(:new)
        end

      end
    end
  end
end