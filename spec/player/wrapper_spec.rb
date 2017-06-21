require "helper"

describe MVLC::Player::Wrapper do

  before(:each) do
    @vlc = Object.new
    expect_any_instance_of(MVLC::Player::Wrapper).to(receive(:player_pid).and_return(2345))
    expect_any_instance_of(MVLC::Player::Wrapper).to(receive(:initialize_player).and_return(@vlc))
    @player = MVLC::Player::Wrapper.new
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
