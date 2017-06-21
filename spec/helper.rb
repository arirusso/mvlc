$:.unshift(File.join("..", "lib"))

require "rspec"
require "mvlc"

# patch so that VLC media player doesn't start
module VLC

  class Server

    def process_spawn(*a)
      1234
    end

  end

end
