require 'spec_helper'
require './spec/fixtures/network_node'

describe DataMapper::Property::UUID do
  before :all do
    @property = DataMapper::TypesFixtures::NetworkNode.properties[:node_uuid]
    @input    = 'b0fc632e-d744-4821-afe3-4ea0701859ee'
    @uuid     = UUIDTools::UUID.random_create
  end

  describe '#valid?' do
    describe "with a String" do
      subject { @property.valid?(@input) }
      it { expect(subject).to be(true) }
    end

    describe "with a UUIDTools::UUID" do
      subject { @property.valid?(@uuid) }
      it { expect(subject).to be(true) }
    end
  end
end
