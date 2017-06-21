require "helper"

describe MVLC::MIDI::MessageHandler do

  before(:each) do
    @handler = MVLC::MIDI::MessageHandler.new
  end

  context "#note_message" do

    before(:each) do
      @message = MIDIMessage::NoteOn.new(0, 10, 100)
    end

    context "callback exists" do

      before(:each) do
        @var = nil
        @callback = proc { |vel| @var = vel }
        @handler.add_callback(:note, @message.note, &@callback)
        expect(@callback).to(receive(:call).once)
      end

      context "has catch-all callback" do

        before(:each) do
          @var2 = nil
          @catchall = proc { |vel| @var2 = vel }
          @handler.add_callback(:note, nil, &@catchall)
          expect(@catchall).to(receive(:call).once)
        end

        it "calls both callbacks" do
          expect(@handler.send(:note_message, @message)).to(be(true))
        end

      end

      context "no catch-all callback" do

        it "calls specific callback" do
          expect(@handler.send(:note_message, @message)).to(be(true))
        end

      end

    end

    context "callback doesn't exist" do

      context "has catch-all callback" do

        before(:each) do
          @var = nil
          @callback = proc { |vel| @var = vel }
          @handler.add_callback(:note, nil, &@callback)
          expect(@callback).to(receive(:call).once)
        end

        it "calls callback" do
          expect(@handler.send(:note_message, @message)).to(be(true))
        end

      end

      context "no catch-all callback" do

        it "does nothing" do
          expect(@handler.send(:note_message, @message)).to_not(be(true))
        end

      end

    end

  end

  context "#cc_message" do

    before(:each) do
      @message = MIDIMessage::ControlChange.new(0, 8, 100)
    end

    context "callback exists" do

      before(:each) do
        @var = nil
        @callback = proc { |vel| @var = vel }
        @handler.add_callback(:cc, @message.index, &@callback)
        expect(@callback).to(receive(:call).once)
      end

      it "calls callback" do
        expect(@handler.send(:cc_message, @message)).to(be(true))
      end

    end

    context "callback doesn't exist" do

      context "has catch-all callback" do

        before(:each) do
          @var = nil
          @callback = proc { |vel| @var = vel }
          @handler.add_callback(:cc, nil, &@callback)
          expect(@callback).to(receive(:call).once)
        end

        it "calls callback" do
          expect(@handler.send(:cc_message, @message)).to(be(true))
        end

      end

      context "no catch-all callback" do

        it "does nothing" do
          expect(@handler.send(:cc_message, @message)).to_not(be(true))
        end

      end

    end

  end

  context "#system_message" do

    before(:each) do
      @message = MIDIMessage::SystemRealtime.new(0x8) # clock
    end

    context "callback exists" do

      before(:each) do
        @var = nil
        @callback = proc { |vel| @var = vel }
        @handler.add_callback(:system, :clock, &@callback)
        expect(@callback).to(receive(:call).once)
      end

      it "calls callback" do
        expect(@handler.send(:system_message, @message)).to(be(true))
      end

    end

    context "callback doesn't exist" do

      it "does nothing" do
        expect(@handler.send(:system_message, @message)).to_not(be(true))
      end

    end

  end

  context "#channel_message" do

    context "omni" do

      before(:each) do
        @channel = nil
      end

      context "control change" do

        before(:each) do
          @message = MIDIMessage::ControlChange.new(0, 8, 100)
          expect(@handler).to(receive(:cc_message).once.with(@message).and_return(true))
        end

        it "handles control change" do
          expect(@handler.send(:channel_message, @channel, @message)).to(be(true))
        end

      end

      context "note" do

        before(:each) do
          @message = MIDIMessage::NoteOn.new(0, 10, 100)
          expect(@handler).to(receive(:note_message).once.with(@message).and_return(true))
        end

        it "handles note" do
          expect(@handler.send(:channel_message, @channel, @message)).to(be(true))
        end

      end

    end

    context "with channel" do

      before(:each) do
        @channel = 5
      end

      context "control change" do

        before(:each) do
          @message = MIDIMessage::ControlChange.new(@channel, 8, 100)
        end

        context "matching channel" do

          before(:each) do
            expect(@handler).to(receive(:cc_message).once.with(@message).and_return(true))
          end

          it "handles control change" do
            expect(@handler.send(:channel_message, @channel, @message)).to(be(true))
          end

        end

        context "non matching channel" do

          before(:each) do
            expect(@handler).to_not(receive(:cc_message))
            @other_message = MIDIMessage::ControlChange.new(@channel + 1, 8, 100)
          end

          it "does nothing" do
            expect(@handler.send(:channel_message, @channel, @other_message)).to_not(be(true))
          end

        end

      end

      context "note" do

        before(:each) do
          @message = MIDIMessage::NoteOn.new(@channel, 10, 100)
        end

        context "matching channel" do

          before(:each) do
            expect(@handler).to(receive(:note_message).once.with(@message).and_return(true))
          end

          it "calls callback" do
            expect(@handler.send(:channel_message, @channel, @message)).to(be(true))
          end

        end

        context "non matching channel" do

          before(:each) do
            expect(@handler).to_not(receive(:note_message))
            @other_message = MIDIMessage::ControlChange.new(@channel + 1, 8, 100)
          end

          it "doesn't call callback" do
            expect(@handler.send(:channel_message, @channel, @other_message)).to(be_nil)
          end

        end

      end

    end

  end

end
