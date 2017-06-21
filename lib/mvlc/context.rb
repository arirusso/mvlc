module MVLC

  # DSL context for interfacing an video player instance with MIDI
  class Context

    include Helper::Numbers
    include Instructions::MIDI
    include Instructions::Player

    attr_reader :midi, :playback_thread, :player

    # @param [UniMIDI::Input, Array<UniMIDI::Input>] midi_input
    # @param [Hash] options
    # @option options [Integer] :midi_buffer_length Length of MIDI message buffer in seconds
    # @option options [Integer] :receive_channel (also: :rx_channel) A MIDI channel to subscribe to. By default, responds to all
    # @yield
    def initialize(midi_input, options = {})
      midi_options = {
        :buffer_length => options[:midi_buffer_length],
        :receive_channel => options[:receive_channel] || options[:rx_channel]
      }
      @midi = MIDI.new(midi_input, midi_options)
      @player = Player.new
    end

    # Start listening for MIDI, start video player
    # @param [Hash] options
    # @option options [Boolean] :background Whether to run in a background thread
    # @return [Boolean]
    def start(options = {})
      @midi.start
      begin
        @playback_thread = playback_loop
        @playback_thread.join unless !!options[:background]
      rescue SystemExit, Interrupt
        stop
      end
      true
    end

    # Stop the player
    # @return [Boolean]
    def stop
      @midi.stop
      @player.quit
      @playback_thread.kill
      true
    end

    private

    # Main playback loop
    def playback_loop
      ::MVLC::Thread.new(:timeout => false) do
        until @player.active?
          sleep(0.1)
        end
        @player.playback_loop
      end
    end

  end

end
