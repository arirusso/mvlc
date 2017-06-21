require "helper"

describe MVLC::Player::State do

  before(:each) do
    @state = MVLC::Player::State.new
  end

  context "#toggle_pause" do

    context "not paused" do

      before(:each) do
        @state.is_paused = false
        expect(@state.paused?).to(eq(false))
        @state.toggle_pause
      end

      it "be paused" do
        expect(@state.paused?).to(eq(true))
      end

    end

    context "paused" do

      before(:each) do
        @state.is_paused = true
        expect(@state.paused?).to(eq(true))
        @state.toggle_pause
      end

      it "unpauses" do
        expect(@state.paused?).to(eq(false))
      end

    end

  end

  context "#progressing?" do

    context "playing" do

      before(:each) do
        @state.is_playing = true
      end

      context "paused" do

        before(:each) do
          @state.is_paused = true
        end

        it "returns false" do
          expect(@state.paused?).to(eq(true))
          expect(@state.playing?).to(eq(true))

          expect(@state.progressing?).to(eq(false))
        end

      end

      context "not paused" do

        before(:each) do
          @state.is_paused = false
        end

        it "returns true" do
          expect(@state.paused?).to(eq(false))
          expect(@state.playing?).to(eq(true))

          expect(@state.progressing?).to(eq(true))
        end

      end

    end

    context "not playing" do

      before(:each) do
        @state.is_playing = false
      end

      context "paused" do

        before(:each) do
          @state.is_paused = true
        end

        it "returns false" do
          expect(@state.paused?).to(eq(true))
          expect(@state.playing?).to(eq(false))

          expect(@state.progressing?).to(eq(false))
        end

      end

      context "not paused" do

        before(:each) do
          @state.is_paused = false
        end

        it "returns false" do
          expect(@state.paused?).to(eq(false))
          expect(@state.playing?).to(eq(false))

          expect(@state.progressing?).to(eq(false))
        end

      end

    end

  end

  context "#eof_possible?" do

    context "not already eof" do

      before(:each) do
        @state.is_eof = false
      end

      context "playing" do

        before(:each) do
          @state.is_playing = true
        end

        context "paused" do

          before(:each) do
            @state.is_paused = true
          end

          it "returns false" do
            expect(@state.eof?).to(eq(false))
            expect(@state.paused?).to(eq(true))
            expect(@state.playing?).to(eq(true))

            expect(@state.eof_possible?).to(eq(false))
          end

        end

        context "not paused" do

          before(:each) do
            @state.is_paused = false
          end

          it "returns true" do
            expect(@state.eof?).to(eq(false))
            expect(@state.paused?).to(eq(false))
            expect(@state.playing?).to(eq(true))

            expect(@state.eof_possible?).to(eq(true))
          end

        end

      end

      context "not playing" do

        before(:each) do
          @state.is_playing = false
        end

        context "paused" do

          before(:each) do
            @state.is_paused = true
          end

          it "returns false" do
            expect(@state.eof?).to(eq(false))
            expect(@state.paused?).to(eq(true))
            expect(@state.playing?).to(eq(false))

            expect(@state.eof_possible?).to(eq(false))
          end

        end

        context "not paused" do

          before(:each) do
            @state.is_paused = false
          end

          it "returns false" do
            expect(@state.eof?).to(eq(false))
            expect(@state.paused?).to(eq(false))
            expect(@state.playing?).to(eq(false))

            expect(@state.eof_possible?).to(eq(false))
          end

        end

      end

    end

    context "already eof" do

      before(:each) do
        @state.is_eof = true
      end

      context "playing" do

        before(:each) do
          @state.is_playing = true
        end

        context "paused" do

          before(:each) do
            @state.is_paused = true
          end

          it "returns false" do
            expect(@state.eof?).to(eq(true))
            expect(@state.paused?).to(eq(true))
            expect(@state.playing?).to(eq(true))

            expect(@state.eof_possible?).to(eq(false))
          end

        end

        context "not paused" do

          before(:each) do
            @state.is_paused = false
          end

          it "returns false" do
            expect(@state.eof?).to(eq(true))
            expect(@state.paused?).to(eq(false))
            expect(@state.playing?).to(eq(true))

            expect(@state.eof_possible?).to(eq(false))
          end

        end

      end

      context "not playing" do

        before(:each) do
          @state.is_playing = false
        end

        context "paused" do

          before(:each) do
            @state.is_paused = true
          end

          it "returns false" do
            expect(@state.eof?).to(eq(true))
            expect(@state.paused?).to(eq(true))
            expect(@state.playing?).to(eq(false))

            expect(@state.eof_possible?).to(eq(false))
          end

        end

        context "not paused" do

          before(:each) do
            @state.is_paused = false
          end

          it "returns false" do
            expect(@state.eof?).to(eq(true))
            expect(@state.paused?).to(eq(false))
            expect(@state.playing?).to(eq(false))

            expect(@state.eof_possible?).to(eq(false))
          end

        end

      end

    end

  end

  context "#handle_eof" do

    before(:each) do
      @state.is_playing = true
      @state.is_eof = false
      expect(@state.eof?).to(be(false))
      expect(@state.playing?).to(be(true))
      @state.handle_eof
    end

    it "flags eof" do
      expect(@state.eof?).to(be(true))
    end

    it "flags not playing" do
      expect(@state.playing?).to(be(false))
    end

  end

  context "#handle_start" do

    before(:each) do
      @state.is_playing = false
      @state.is_eof = true
      expect(@state.eof?).to(be(true))
      expect(@state.playing?).to(be(false))
      @state.handle_start
    end

    it "flags not eof" do
      expect(@state.eof?).to(be(false))
    end

    it "flags as playing" do
      expect(@state.playing?).to(be(true))
    end

  end

end
