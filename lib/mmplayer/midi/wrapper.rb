module MMPlayer

  module MIDI

    # Wrapper for MIDI functionality
    class Wrapper

      attr_reader :channel, :listener, :message_handler

      # @param [UniMIDI::Input, Array<UniMIDI::Input>] input
      # @param [Hash] options
      # @option options [Fixnum] :buffer_length Length of MIDI message buffer in seconds
      # @option options [Fixnum] :receive_channel A MIDI channel to subscribe to. By default, responds to all
      def initialize(input, options = {})
        @buffer_length = options[:buffer_length]
        @channel = options[:receive_channel]

        @message_handler = MessageHandler.new
        @listener = MIDIEye::Listener.new(input)
      end

      # Add a callback for a given MIDI system message
      # @param [String, Symbol] command The MIDI system command eg :start, :stop
      # @param [Proc] callback The callback to execute when the given MIDI command is received
      # @return [Hash]
      def add_system_callback(command, &callback)
        @message_handler.add_callback(:system, command, &callback)
      end

      # Add a callback for a given MIDI note
      # @param [Fixnum, String, nil] note The MIDI note to add a callback for eg 64 "E4"
      # @param [Proc] callback The callback to execute when the given MIDI note is received
      # @return [Hash]
      def add_note_callback(note, &callback)
        @message_handler.add_note_callback(note, &callback)
      end

      # Add a callback for a given MIDI control change
      # @param [Fixnum, nil] index The MIDI control change index to add a callback for eg 10
      # @param [Proc] callback The callback to execute when the given MIDI control change is received
      # @return [Hash]
      def add_cc_callback(index, &callback)
        @message_handler.add_callback(:cc, index, &callback)
      end

      # Stop the MIDI listener
      # @return [Boolean]
      def stop
        @listener.stop
      end

      # Change the subscribed MIDI channel (or nil for all)
      # @param [Fixnum, nil] channel
      # @return [Fixnum, nil]
      def channel=(channel)
        @listener.event.clear
        @channel = channel
        initialize_listener if @listener.running?
        @channel
      end

      # Start the MIDI listener
      # @return [Boolean]
      def start
        initialize_listener
        @listener.start(:background => true)
        true
      end

      # Whether the player is subscribed to all channels
      # @return [Boolean]
      def omni?
        @channel.nil?
      end

      private

      # Handle a new MIDI event received
      # @param [Hash] event
      # @return [Hash]
      def handle_new_event(event)
        if @buffer_length.nil? || event[:timestamp].nil? || event[:timestamp] >= Time.now.to_i - @buffer_length
          message = event[:message]
          @message_handler.process(@channel, message)
          event
        end
      end

      # Populate the MIDI listener callback
      # @return [MIDIEye::Listener]
      def initialize_listener
        @listener.on_message { |event| handle_new_event(event) }
        @listener
      end

    end

  end
end
