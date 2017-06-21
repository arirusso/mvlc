require "helper"

describe MVLC::Player::Wrapper do

  before(:each) do
    @vlc = Object.new
    expect_any_instance_of(MVLC::Player::Wrapper).to(receive(:player_pid).and_return(2345))
    expect_any_instance_of(MVLC::Player::Wrapper).to(receive(:initialize_player).and_return(@vlc))
    @player = MVLC::Player::Wrapper.new
  end

  context "#volume=" do

    before(:each) do
      expect(@player.player).to(receive(:volume).once.with(96.0).and_return(true))
      @player.volume = 40
    end

    it "sets local state" do
      expect(@player.state.volume).to(eq(96.0))
    end

  end

  context "#seek_percent" do

    before(:each) do
      expect(@player.player).to(receive(:length).once.and_return(10))
      expect(@player.player).to(receive(:seek).once.with(3.0).and_return(true))
    end

    it "seeks" do
      expect(@player.seek_percent(30)).to(be(true))
    end

  end

  context "#active?" do

    context "when player resource exists" do

      it "returns true" do
        expect(@player.active?).to(be(true))
      end

    end

    context "when player resource doesn't exist" do

      before(:each) do
        @player.instance_variable_set("@player", nil)
      end

      it "returns false" do
        expect(@player.active?).to(be(false))
      end

    end

  end

  context "#pause" do

    before(:each) do
      expect(@player.state.paused?).to(be(false))
      expect(@player.player).to(receive(:pause).once.and_return(true))
      @player.pause
    end

    it "sets local state" do
      expect(@player.state.paused?).to(be(true))
    end

  end

  context "#add_progress_callback" do

    before(:each) do
      @callback = Proc.new { |progress| puts "hello" }
      @player.add_progress_callback(&@callback)
      @callbacks = @player.instance_variable_get("@callback")
    end

    it "sets progress callback" do
      expect(@callbacks[:progress]).to_not(be_nil)
      expect(@callbacks[:progress]).to(eq(@callback))
    end

  end

  context "#add_end_of_file_callback" do

    before(:each) do
      @callback = Proc.new { puts "hello" }
      @player.add_end_of_file_callback(&@callback)
      @callbacks = @player.instance_variable_get("@callback")
    end

    it "sets progress callback" do
      expect(@callbacks[:end_of_file]).to_not(be_nil)
      expect(@callbacks[:end_of_file]).to(eq(@callback))
    end

  end

  context "#quit" do

    before(:each) do
      expect(@player).to(receive(:kill_player).once.and_return(true))
    end

    it "exits video player and kills the player thread" do
      expect(@player.quit).to(be(true))
    end

  end

  context "#play" do

    before(:each) do
      expect(@vlc).to(receive(:play))
    end

    it "plays video" do
      expect(@player.play("file.mov")).to(be(true))
    end

  end

end
