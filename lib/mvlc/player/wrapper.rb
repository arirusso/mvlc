module MVLC

  module Player

    # Wrapper for video player functionality
    class Wrapper

      VOLUME_FACTOR = 2.4 # Factor at which volume value is scaled

      extend Forwardable

      attr_reader :state, :pid, :player

      # @param [Hash] options
      def initialize(options = {})
        @callback = {}
        @state = State.new
        @player = initialize_player
        @pid = player_pid
      end

      # Set the volume level to the given value.
      # Value is expected to be 0..100 but this is not strictly enforced
      # @param [Integer] value
      # @return [Integer]
      def volume=(value)
        @state.volume = value * VOLUME_FACTOR
        @player.volume(@state.volume)
        @state.volume
      end
      alias_method :set_volume, :volume=

      # Seek to the given percent in the currently playing file
      # Value is expected to be 0..100
      # @param [Integer] value
      # @return [Integer]
      def seek_percent(percent)
        begin
          length_in_seconds = @player.length
          seconds = length_in_seconds * (percent / 100.0)
          @player.seek(seconds)
        rescue VLC::ReadTimeoutError, VLC::BrokenConnectionError
        end
      end

      # Play a media file
      # @param [String] file
      # @return [Boolean]
      def play(file)
        if @player.nil?
          false
        else
          @player.play(file)
          handle_start
          true
        end
      end

      # Is the video player active?
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
          handle_playback_events
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

      # Exit the video player
      # @return [Boolean]
      def quit
        kill_player
        true
      end

      # Add all of the video player methods to the wrapper as instructions
      def method_missing(method, *args, &block)
        if @player.respond_to?(method)
          @player.send(method, *args, &block)
        else
          super
        end
      end

      # Add all of the video player methods to the wrapper as instructions
      def respond_to_missing?(method, include_private = false)
        super || @player.respond_to?(method)
      end

      private

      # Fire playback event callbacks when appropriate during
      # the playback loop
      # @return [Boolean]
      def handle_playback_events
        handle_eof if handle_eof?
        handle_progress if handle_progress?
        true
      end

      # Instantiate the VLC player instance
      # @return [VLC::System]
      def initialize_player
        VLC::System.new(headless: true)
      end

      # The OS PID of the player
      # @return [Integer]
      def player_pid
        @player.server.instance_variable_get("@pid")
      end

      # Kill the VLC player instance
      # @return [Boolean]
      def kill_player
        begin
          @player.connection.write("quit")
        rescue Errno::EBADF
        end
        # TODO: Process.kill not working here
        `kill -9 #{@pid}` unless @pid.nil?
        @player.server.stop
        true
      end

      # Should a progress callback be fired?
      # @return [Boolean]
      def handle_progress?
        @state.progressing? && progress_callback?
      end

      # Has a progress callback been specified?
      # @return [Boolean]
      def progress_callback?
        !@callback[:progress].nil?
      end

      # Has an EOF callback been specified?
      # @return [Boolean]
      def eof_callback?
        !@callback[:end_of_file].nil?
      end

      # Should an EOF callback be fired?
      # @return [Boolean]
      def handle_eof?
        eof? && eof_callback?
      end

      # Fire the progress callback. Used during the playback loop
      # @return [Boolean]
      def handle_progress
        @callback[:progress].call(@player.progress)
        true
      end

      # Handle the end of playback for a single media file
      # @return [Boolean]
      def handle_eof
        @callback[:end_of_file].call
        @state.handle_eof
        true
      end

      # Handle the beginning of playback for a single media file
      # @return [Boolean]
      def handle_start
        @state.handle_start
        true
      end

      # Is media playing?
      # @return [Boolean]
      def playing?
        begin
          @player.playing?
        rescue VLC::ReadTimeoutError, VLC::BrokenConnectionError
          false
        end
      end

      # Has the end of a media file been reached?
      # @return [Boolean]
      def eof?
        @state.eof_possible? && !playing?
      end

    end

  end
end
