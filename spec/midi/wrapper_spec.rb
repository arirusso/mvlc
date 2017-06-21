require "helper"

describe MVLC::MIDI::Wrapper do

  before(:each) do
    @input = Object.new
    @midi = MVLC::MIDI::Wrapper.new(@input)
  end

  context "#handle_new_event" do

    context "with no buffer length" do

      before(:each) do
        expect(@midi.message_handler).to(receive(:process).once)
        @event = {
          :message => MIDIMessage::NoteOn.new(0, 64, 120),
          :timestamp=> 9266.395330429077
        }
        @result = @midi.send(:handle_new_event, @event)
      end

      it "returns event" do
        expect(@result).to_not(be_nil)
        expect(@result).to(eq(@event))
      end

    end

    context "with buffer length" do

      context "recent message" do

        before(:each) do
          expect(@midi.message_handler).to(receive(:process).once)
          @event = {
            :message => MIDIMessage::NoteOn.new(0, 64, 120),
            :timestamp=> 9266.395330429077
          }
          @result = @midi.send(:handle_new_event, @event)
        end

        it "returns event" do
          expect(@result).to_not(be_nil)
          expect(@result).to(eq(@event))
        end

      end

      context "with too-old message" do

        before(:each) do
          @midi.instance_variable_set("@buffer_length", 1)
          @midi.instance_variable_set("@start_time", Time.now.to_i)
          sleep(2)
          expect(@midi.message_handler).to_not(receive(:process))
          @event = {
            :message => MIDIMessage::NoteOn.new(0, 64, 120),
            :timestamp => 0.1
          }
          @result = @midi.send(:handle_new_event, @event)
        end

        it "does not return event" do
          expect(@result).to(be_nil)
        end

      end

    end

  end

  context "#initialize_listener" do

    before(:each) do
      expect(@midi.listener).to(receive(:on_message).once)
      @result = @midi.send(:initialize_listener)
    end

    it "returns listener" do
      expect(@result).to_not(be_nil)
      expect(@result).to(be_kind_of(MIDIEye::Listener))
    end

  end

  context "#start" do

    before(:each) do
      expect(@midi.listener).to(receive(:on_message).once)
      expect(@midi.listener).to(receive(:start).once)
    end

    it "activates callbacks" do
      expect(@midi.start).to(be(true))
    end

  end

  context "#add_note_callback" do

    before(:each) do
      @var = nil
      @midi.add_note_callback(10) { |vel| @var = vel }
    end

    it "stores callback" do
      expect(@midi.message_handler.callback[:note][10]).to_not(be_nil)
      expect(@midi.message_handler.callback[:note][10]).to(be_kind_of(Proc))
    end

  end

  context "#add_system_callback" do

    before(:each) do
      @var = nil
      @midi.add_system_callback(:start) { |val| @var = val }
    end

    it "stores callback" do
      expect(@midi.message_handler.callback[:system][:start]).to_not(be_nil)
      expect(@midi.message_handler.callback[:system][:start]).to(be_kind_of(Proc))
    end

  end

  context "#add_cc_callback" do

    before(:each) do
      @var = nil
      @midi.add_cc_callback(2) { |val| @var = val }
    end

    it "stores callback" do
      expect(@midi.message_handler.callback[:cc][2]).to_not(be_nil)
      expect(@midi.message_handler.callback[:cc][2]).to(be_kind_of(Proc))
    end

  end

  context "#channel=" do

    before(:each) do
      # stub out MIDIEye
      @listener = Object.new
      expect(@listener).to(receive(:event).and_return([]))
      @midi.instance_variable_set("@listener", @listener)
    end

    context "before listener is started" do

      before(:each) do
        expect(@listener).to(receive(:running?).and_return(false))
      end

      it "changes channel" do
        expect(@midi.channel = 3).to(eq(3))
        expect(@midi.channel).to(eq(3))
        expect(@midi.omni?).to_not(be(true))
      end

      it "sets channel to nil" do
        expect(@midi.channel = nil).to(be_nil)
        expect(@midi.channel).to(be_nil)
        expect(@midi.omni?).to(be(true))
      end
    end

    context "after listener is started" do

      before(:each) do
        expect(@listener).to(receive(:running?).and_return(false))
      end

      it "changes channel" do
        expect(@midi.channel = 3).to(eq(3))
        expect(@midi.channel).to(eq(3))
        expect(@midi.omni?).to_not(be(true))
      end

      it "sets channel to nil" do
        expect(@midi.channel = nil).to(be_nil)
        expect(@midi.channel).to(be_nil)
        expect(@midi.omni?).to(be(true))
      end

    end

  end

end
