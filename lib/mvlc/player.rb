require "mvlc/player/invoker"
require "mvlc/player/messenger"
require "mvlc/player/state"
require "mvlc/player/wrapper"

module MVLC

  module Player

    def self.new(*args)
      ::MVLC::Player::Wrapper.new(*args)
    end

  end

end
