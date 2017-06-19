require "helper"

class MVLC::Instructions::PlayerTest < Minitest::Test

  context "Player" do

    setup do
      @player = Object.new
      @player.stubs(:quit)
      @player.stubs(:seek).returns(true)
      VLC::System.stubs(:new).returns(@player)
      @input = Object.new
      @context = MVLC::Context.new(@input)
      assert @context.kind_of?(MVLC::Instructions::Player)
    end

    context "#on_end_of_file" do

      setup do
        @context.player.expects(:add_end_of_file_callback).once.returns({})
      end

      teardown do
        @context.player.unstub(:add_end_of_file_callback)
      end

      should "assign callback" do
        refute_nil @context.on_end_of_file { something }
      end

    end

    context "#method_missing" do

      setup do
        @context.player.expects(:mplayer_send).once.with(:seek, 50, :percent).returns(true)
      end

      teardown do
        @context.player.unstub(:mplayer_send)
      end

      should "delegate" do
        refute_nil @context.seek(50, :percent)
      end

    end

    context "#respond_to?" do

      setup do
        @context.player.expects(:mplayer_respond_to?).once.with(:seek).returns(true)
      end

      teardown do
        @context.player.unstub(:mplayer_respond_to?)
      end

      should "delegate" do
        refute_nil @context.respond_to?(:seek)
      end

    end

  end
end
