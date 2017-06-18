require "mvlc/midi/message_handler"
require "mvlc/midi/wrapper"

module MVLC

  module MIDI

    def self.new(*args)
      ::MVLC::MIDI::Wrapper.new(*args)
    end

  end

end
