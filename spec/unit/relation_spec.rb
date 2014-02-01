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
  end
end