require "helper"

class MVLC::Player::WrapperTest < Minitest::Test

  context "Wrapper" do

    setup do
      @player = Object.new
      @player.stubs(:quit)
      conn = Object.new
      conn.stubs(:write)
      @player.stubs(:connection).returns(conn)
      VLC::System.stubs(:new).returns(@player)
      @player = MVLC::Player::Wrapper.new
    end

    context "#quit" do

      setup do
        #@vlc.expects(:quit).once
        #@player.instance_variable_get("@threads").first.expects(:kill).once
      end

      teardown do
        #@vlc.unstub(:quit)
      #  @player.instance_variable_get("@threads").first.unstub(:kill)
      end

      should "exit MPlayer and kill the player thread" do
        assert @player.quit
      end

    end

    context "#play" do

      setup do
        @player.expects(:play).once.returns(true)
      end

      teardown do
        @player.unstub(:play)
      end

      should "lazily invoke mplayer and play" do
        assert @player.play("file.mov")
        #refute_nil @player.instance_variable_get("@player")
      end

    end

  end

end
