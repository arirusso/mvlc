module MMPlayer

  class Player

    def initialize(options = {})
      @flags = "-fixed-vo -idle"
      @flags += " #{options[:flags]}" unless options[:flags].nil?
    end

    def play(file)
      ensure_player(file)
      @player.load_file(file) unless @player.nil?
    end

    def active?
      !@player.nil? && !@player.stdout.gets.nil?
    end

    def method_missing(method, *args, &block)
      if @player.respond_to?(method)
        @player.send(method, *args, &block)
      else
        super
      end
    end

    def respond_to_missing?(method, include_private = false)
      super || @player.respond_to?(method)
    end

    private

    def ensure_player(file)
      @player ||= MPlayer::Slave.new(file, :options => @flags)
    end

  end

end
