require 'rspec'

require 'active_delegator/relation'

module ActiveDelegator
  describe Relation do

    let(:ar_relation) { double('relation') }
    let(:mapper_class) { double('mapper_class') }

    let(:relation) { Relation.new(ar_relation, mapper_class) }

    describe '#where' do
      it 'should send where to relation' do
        ar_relation.should_receive(:where)
        relation.where
      end

      it 'is wrapped in a relation' do
        ar_relation.should_receive(:where)
        expect(relation.where).to be_a(Relation)
      end
    end

    context 'enumerable' do
      let(:mapper_object) { double('mapper_object') }
      let(:store) { double('store') }

      describe '#to_a' do

        it 'delegates to the relation' do
          ar_relation.stub(:to_a => [])
          ar_relation.should_receive(:to_a)
          relation.to_a
        end

        it 'caches the result' do
          ar_relation.stub(:to_a => [])
          ar_relation.should_receive(:to_a).exactly(1).times
          relation.to_a
          relation.to_a
        end

        it 'returns a different object each time' do
          ar_relation.stub(:to_a => [])
          expect(relation.to_a).to_not equal(relation.to_a)
        end

        it 'wraps the stores in mappers' do
          ar_relation.stub(:to_a => [store] * 2)
          mapper_class.stub(:new => mapper_object)

          mapper_class.should_receive(:new).exactly(2).times.with(store)

          expect(relation.to_a).to eq([mapper_object] * 2)
        end
      end

      describe '#each' do
        it 'yields mapper objects' do
          ar_relation.stub(:to_a => [store] * 2)
          mapper_class.stub(:new => mapper_object)

          mapper_class.should_receive(:new).exactly(2).times.with(store)

          expect { |b| relation.each(&b) }.to yield_successive_args(*([mapper_object] * 2))
        end
      end
    end
  end
end