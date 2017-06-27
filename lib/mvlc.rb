# MVLC
# Control VLC media player with MIDI
#
# (c)2017 Ari Russo
# Apache 2.0 License

# libs
require "forwardable"
require "midi-eye"
require "scale"
require "timeout"
require "unimidi"
require "vlc-client"

# modules
require "mvlc/helper/numbers"
require "mvlc/instructions"
require "mvlc/midi"
require "mvlc/player"
require "mvlc/thread"

# classes
require "mvlc/context"

module MVLC

  VERSION = "0.0.7"

  # Shortcut to Context constructor
  def self.new(*args, &block)
    Context.new(*args, &block)
  end

end
