require 'helpers'

describe Compass::Magick::Types::Solid do
  describe "#initialize" do
    it "should assert arguments' type" do
      lambda { Compass::Magick::Types::Solid.new('#ff0000') }.should raise_error(Compass::Magick::TypeMismatch)
    end
  end

  subject { Compass::Magick::Types::Solid.new(Sass::Script::Color.new([255, 0, 0])) }

  it { should respond_to(:color) }

  it "should generate a solid Canvas" do
    subject.to_canvas(Sass::Script::Number.new(100), Sass::Script::Number.new(100)).get_pixel(0, 0).should == ChunkyPNG::Color.rgba(255, 0, 0, 255)
  end
end
