module MVLC

  module Player

    class State

      attr_accessor :is_eof, :is_paused, :is_playing, :volume
      alias_method :eof?, :is_eof
      alias_method :pause?, :is_paused
      alias_method :paused?, :is_paused
      alias_method :play?, :is_playing
      alias_method :playing?, :is_playing

      def initialize
        @is_eof = false
        @is_playing = false
        @is_paused = false
        @volume = nil
      end

      def toggle_pause
        @is_paused = !@is_paused
      end

      def progressing?
        @is_playing && !@is_paused
      end

      def eof_possible?
        @is_playing && !@is_paused && !@is_eof
      end

      def handle_eof
        @is_eof = true
        @is_playing = false
      end

      def handle_start
        @is_playing = true
        @is_eof = false
      end

    end
  end
end
