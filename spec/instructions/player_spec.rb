require "helper"

describe MVLC::Instructions::Player do

  before(:each) do
    @player = Object.new
    expect(@player).to(receive(:server))
    expect_any_instance_of(MVLC::Player::Wrapper).to(receive(:initialize_player).and_return(@player))
    @input = Object.new
    @context = MVLC::Context.new(@input)
    expect(@context).to(be_kind_of(MVLC::Instructions::Player))
  end

  context "#on_end_of_file" do

    before(:each) do
      expect(@context.player).to(receive(:add_end_of_file_callback).once.and_return({}))
    end

    it "assigns callback" do
      expect(@context.on_end_of_file { something }).to_not(be_nil)
    end

  end

end
