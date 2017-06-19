module MVLC

  module Player

    # Wrapper for MPlayer functionality
    class Wrapper

      extend Forwardable

      attr_reader :state, :player

      # @param [Hash] options
      def initialize(options = {})
        @callback = {}
        @state = State.new
        @player = VLC::System.new(headless: true)
      end

      # Play a media file
      # @param [String] file
      # @return [Boolean]
      def play(file)
        if @player.nil?
          false
        else
          @player.play(file)
          true
        end
      end

      # Is MPlayer active?
      # @return [Boolean]
      def active?
        !@player.nil?
      end

      # Toggles pause
      # @return [Boolean]
      def pause
        @state.toggle_pause
        @player.pause
        @state.pause?
      end

      # Handle events while the player is running
      # @return [Boolean]
      def playback_loop
        loop do
          handle_eof if handle_eof?
          sleep(0.05)
        end
        true
      end

      # Add a callback to be called when progress is updated during playback
      # @param [Proc] block
      # @return [Boolean]
      def add_progress_callback(&block)
        @callback[:progress] = block
        true
      end

      # Add a callback to be called at the end of playback of a media file
      # @param [Proc] block
      # @return [Boolean]
      def add_end_of_file_callback(&block)
        @callback[:end_of_file] = block
        true
      end

      # Cause MPlayer to exit
      # @return [Boolean]
      def quit
        @player.quit
        true
      end

      # Add all of the MPlayer::Slave methods to the context as instructions
      def method_missing(method, *args, &block)
        if @player.respond_to?(method)
          @player.send(method, *args, &block)
        else
          super
        end
      end

      # Add all of the MPlayer::Slave methods to the context as instructions
      def respond_to_missing?(method, include_private = false)
        super || @player.respond_to?(method)
      end

      private

      def handle_progress?
        @state.progressing? && progress_callback?
      end

      def progress_callback?
        !@callback[:progress].nil?
      end

      def eof_callback?
        !@callback[:end_of_file].nil?
      end

      def handle_eof?
        eof? && eof_callback?
      end

      # Has the end of a media file been reached?
      # @return [Boolean]
      def eof?
        @state.eof_reached? && get_player_output.size < 1
      end

    end

  end
end
