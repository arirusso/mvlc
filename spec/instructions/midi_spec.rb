require "helper"

describe MVLC::Instructions::MIDI do

  before(:each) do
    @input = Object.new
    @player = Object.new
    expect(@player).to(receive(:server))
    expect_any_instance_of(MVLC::Player::Wrapper).to(receive(:initialize_player).and_return(@player))
    @context = MVLC::Context.new(@input)
    expect(@context).to(be_kind_of(MVLC::Instructions::MIDI))
  end

  context "#note" do

    before(:each) do
      expect(@context.midi).to(receive(:add_note_callback).once.and_return({}))
    end

    it "assigns callback" do
      expect(@context.note(1) { something }).to_not(be_nil)
    end

  end

  context "#cc" do

    before(:each) do
      expect(@context.midi).to(receive(:add_cc_callback).once.and_return({}))
    end

    it "assigns callback" do
      expect(@context.cc(1) { |val| something }).to_not(be_nil)
    end

  end

  context "#system" do

    before(:each) do
      expect(@context.midi).to(receive(:add_system_callback).once.and_return({}))
    end

    it "assigns callback" do
      expect(@context.system(:stop) { |val| something }).to_not(be_nil)
    end

  end

  context "#receive_channel" do

    before(:each) do
      expect(@context.midi).to(receive(:channel=).once.with(3).and_return(3))
    end

    it "assigns callback" do
      expect(@context.receive_channel(3)).to_not(be_nil)
    end

  end

end
