# mmplayer

Control [VLC Media Player](https://en.wikipedia.org/wiki/VLC_media_player) with MIDI

*This is a fork of [mmplayer](https://github.com/arirusso/mvlc), a gem to control MPlayer with MIDI*

Enabling VLC to be controlled by MIDI opens up a host of possibilities for live video performance, media automation and more

This project provides a Ruby DSL to define realtime interactions between MIDI input and VLC

## Install

You'll need to install VLC before using this.  More information about that is available on [the VLC website](http://www.videolan.org/vlc/index.html)

This project itself can be installed as a Ruby Gem using

`gem install mvlc`

Or if you're using Bundler, add this to your Gemfile

`gem "mvlc"`

## Usage

```ruby
require "mvlc"

@input = UniMIDI::Input.gets

@player = MVLC.new(@input) do

  rx_channel 0

  system(:start) { play("1.mov") }

  note(1) { play("2.mov") }
  note("C2") { play("3.mov") }

  cc(1) { |value| set_volume(value) }
  cc(20) { |value| seek_percent(to_percent(value)) }

  eof { puts "finished" }

end

@player.start

```

An annotated breakdown of this example can be found [here](https://github.com/arirusso/mvlc/blob/master/examples/simple.rb)

## License

Apache 2.0, See LICENSE file

Copyright (c) 2017 [Ari Russo](http://arirusso.com)
