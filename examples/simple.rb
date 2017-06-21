#!/usr/bin/env ruby
$:.unshift(File.join("..", "lib"))

# Assign MIDI controls to VLC
require "mvlc"

# Prompt the user to select a MIDI input
@input = UniMIDI::Input.gets

@player = MVLC.new(@input) do

  # Subscribe to MIDI channel 0 only for received messages.
  # MVLC will respond to all channels by default
  rx_channel 0

  # When a MIDI start message is received, start playing the media file 1.mov
  note(0) { play("../spec/media/1.mov") }

  # When MIDI note 1 is received: a media file 2.mov will begin playing
  note(1) { play("../spec/media/2.mov") }

  # When MIDI note C2 (aka 36) is received: a media file 3.mov will begin playing
  note(2) { play("../spec/media/3.mov") }

  # When MIDI control change 1 is received...
  cc(3) do |value|
    percent = to_percent(value) # The received value is converted to percentage eg 0..100
    volume(value) # the media volume is set to that percentage
  end

  # When MIDI control change 20 is received...
  cc(4) do |value|
    percent = to_percent(value) # The received value is converted to percentage eg 0..100
    seek_percent(percent) # That position in the media file is then moved to
  end

  # In addition to MIDI callbacks, there are callbacks for the player:

  # When a media file ends playing
  eof { puts "finished" }

end

# Start listening for the MIDI messages described above
@player.start

# The program can also be run in a background thread by passing `@player.start(:background => true)`
