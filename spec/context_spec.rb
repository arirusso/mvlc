require "helper"

describe MVLC::Context do

  before(:each) do
    @input = Object.new
    @player = Object.new
    expect(@player).to(receive(:server))
    expect_any_instance_of(MVLC::Player::Wrapper).to(receive(:initialize_player).and_return(@player))
    @context = MVLC::Context.new(@input)
  end

  context "#playback_loop" do

    context "player is running" do

      before(:each) do
        expect(@context.player).to(receive(:active?).and_return(true))
        expect(@context.player).to(receive(:playback_loop).and_return(true))
      end

      it "begins player loop" do
        expect(@context.send(:playback_loop)).to(be(true))
      end

    end

  end

  context "#start" do

    before(:each) do
      expect(@context.midi.listener).to(receive(:start))
      expect(@context).to_not(receive(:stop))
      expect(@context.start(:background => true)).to(be(true))
    end

    it "populates playback thread" do
      expect(@context.playback_thread).to_not(be_nil)
      expect(@context.playback_thread).to(be_kind_of(Thread))
    end

  end

  context "#stop" do

    before(:each) do
      expect(@context.midi.listener).to(receive(:start))
      expect_any_instance_of(MVLC::Player::Wrapper).to(receive(:kill_player).once.and_return(true))
      expect(@context.midi.listener).to(receive(:stop).once)
      expect(@context.start(:background => true)).to(be(true))
    end

    it "stops player" do
      expect(@context.stop).to(be(true))
    end

  end

end
