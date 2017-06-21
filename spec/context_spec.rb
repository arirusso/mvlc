require "helper"

describe MVLC::Context do

  before(:each) do
    @input = Object.new
    @player = Object.new
    expect(@player).to(receive(:server))
    expect_any_instance_of(MVLC::Player::Wrapper).to(receive(:initialize_player).and_return(@player))
    @context = MVLC::Context.new(@input)

    expect(@context.midi.listener).to(receive(:start))
  end

  context "#start" do

    it "activates player" do
      expect(@context.start(:background => true)).to(be(true))
    end

  end

  context "#stop" do

    before(:each) do
      expect_any_instance_of(MVLC::Player::Wrapper).to(receive(:kill_player).once.and_return(true))
      expect(@context.midi.listener).to(receive(:stop).once)
      expect(@context.start(:background => true)).to(be(true))
    end

    it "stops player" do
      expect(@context.stop).to(be(true))
    end

  end

end
