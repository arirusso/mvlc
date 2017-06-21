require "helper"

describe MVLC::Helper::Numbers do

  before(:each) do
    @util = Object.new
    @util.class.send(:include, MVLC::Helper::Numbers)
  end

  context "#to_midi_value" do

    it "converts 0" do
      val = @util.to_midi_value(0)
      expect(val).to_not(be_nil)
      expect(val).to(eq(0x0))
    end

    it "converts 64" do
      val = @util.to_midi_value(50)
      expect(val).to_not(be_nil)
      expect(val).to(eq(0x40))
    end

    it "converts 127" do
      val = @util.to_midi_value(100)
      expect(val).to_not(be_nil)
      expect(val).to(eq(0x7F))
    end

  end

  context "#to_percent" do

    it "converts 0%" do
      val = @util.to_percent(0x0)
      expect(val).to_not(be_nil)
      expect(val).to(eq(0))
    end

    it "converts 50%" do
      val = @util.to_percent(0x40)
      expect(val).to_not(be_nil)
      expect(val).to(eq(50))
    end

    it "converts 100%" do
      val = @util.to_percent(0x7F)
      expect(val).to_not(be_nil)
      expect(val).to(eq(100))
    end
    
  end
end
