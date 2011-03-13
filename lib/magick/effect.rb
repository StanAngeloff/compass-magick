module Compass::Magick
  # A class that executes a processing block on each {Canvas} pixel.
  #
  # @example
  #
  #     # Turn all pixels opaque
  #     Effect.new do |pixel|
  #       pixel | 0x000000ff
  #     end
  class Effect < Command

    # Initializes a new Effect instance.
    #
    # @param [Proc] process The processing block to execute.
    def initialize(&process)
      @process = process
      @block   = lambda do |canvas|
        for y in 0...canvas.height do
          for x in 0...canvas.width do
            canvas.set_pixel(x, y, @process.call(canvas.get_pixel(x, y)))
          end
        end
      end
    end
  end
end

