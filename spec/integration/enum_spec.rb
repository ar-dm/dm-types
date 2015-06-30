require 'spec_helper'
require './spec/fixtures/ticket'

describe DataMapper::TypesFixtures::Ticket do
  supported_by :all do
    describe 'that is dumped and then loaded' do
      before do
        @resource = DataMapper::TypesFixtures::Ticket.new(
          :title  => "Can't order by aggregated fields",
          :id     => 789,
          :body   => "I'm trying to use the aggregate method and sort the results by a summed field, but it doesn't work.",
          :status => 'confirmed'
        )

        expect(@resource.save).to be(true)
        @resource.reload
      end

      it 'preserves property value' do
        expect(@resource.status).to eq(:confirmed)
      end
    end

    describe 'that is supplied a matching enumeration value' do
      before do
        @resource = DataMapper::TypesFixtures::Ticket.new(:status => :assigned)
      end

      it 'typecasts it for outside reader' do
        expect(@resource.status).to eq(:assigned)
      end
    end

    describe '#get' do
      before do
        @resource = DataMapper::TypesFixtures::Ticket.new(
          :title  => '"sudo make install" of drizzle fails because it tries to chown mysql',
          :id     => 257497,
          :body   => "Note that at the very least, there should be a check to see whether or not the user is created before chown'ing a file to the user.",
          :status => 'confirmed'
        )
        expect(@resource.save).to be(true)
      end

      it 'supports queries with equality operator on enumeration property' do
        expect(DataMapper::TypesFixtures::Ticket.all(:status => :confirmed)).
          to include(@resource)
      end

      it 'supports queries with inequality operator on enumeration property' do
        expect(DataMapper::TypesFixtures::Ticket.all(:status.not => :confirmed)).
          not_to include(@resource)
      end
    end

    describe 'with value unknown to enumeration property' do
      before do
        @resource = DataMapper::TypesFixtures::Ticket.new(:status => :undecided)
      end

      # TODO: consider sharing shared spec exampels with dm-validations,
      #       which has 'invalid model' shared group
      it 'is invalid (auto validation for :within kicks in), has errors, and a meaningful error message' do
        expect(@resource).not_to be_valid
        expect(@resource.errors).not_to be_empty
        expect(@resource.errors.on(:status)).to include('Status must be one of unconfirmed, confirmed, assigned, resolved, not_applicable')
      end
    end
  end
end
