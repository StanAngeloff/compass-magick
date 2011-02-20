require 'helpers'

describe Compass::Magick::Types::Gradients::Linear do
  describe "#initialize" do
    it "should assert arguments' type" do
      lambda { Compass::Magick::Types::Gradients::Linear.new(45, 'string') }.should raise_error(Compass::Magick::TypeMismatch)
      lambda { Compass::Magick::Types::Gradients::Linear.new(Sass::Script::Number.new(45), 'string') }.should raise_error(Compass::Magick::TypeMismatch)
    end
  end

  subject { Compass::Magick::Types::Gradients::Linear.new(
    Sass::Script::Number.new(45), [
      [Sass::Script::Number.new(0),   Sass::Script::Color.new([255,   0,   0, 1])],
      [Sass::Script::Number.new(50),  Sass::Script::Color.new([  0, 255,   0, 0.5])],
      [Sass::Script::Number.new(100), Sass::Script::Color.new([  0,   0, 255, 1])]
    ]
  ) }

  it { should respond_to(:angle) }
  it { should respond_to(:stops) }

  it "should generate a linear-filled Canvas" do
    canvas = subject.to_canvas(Sass::Script::Number.new(101), Sass::Script::Number.new(101))
    canvas.get_pixel(  0,   0).should == ChunkyPNG::Color.rgba(255,   0,   0, 255)
    canvas.get_pixel( 50,  50).should == ChunkyPNG::Color.rgba(  0, 255,   0, 127)
    canvas.get_pixel(100, 100).should == ChunkyPNG::Color.rgba(  0,   0, 255, 255)
  end

  describe "#to_canvas" do
    it "should assert arguments' type" do
      lambda {
        Compass::Magick::Types::Gradients::Linear.new(Sass::Script::Number.new(45), [['#ff0000']]).to_canvas(
          Sass::Script::Number.new(100),
          Sass::Script::Number.new(100)
        )
      }.should raise_error(ArgumentError)
      lambda {
        Compass::Magick::Types::Gradients::Linear.new(Sass::Script::Number.new(45), [[0, '#ff0000']]).to_canvas(
          Sass::Script::Number.new(100),
          Sass::Script::Number.new(100)
        )
      }.should raise_error(Compass::Magick::TypeMismatch)
    end
  end
end
