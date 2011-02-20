require 'helpers'

describe Compass::Magick::Canvas do
  describe "#initialize" do
    it "should assert arguments' type" do
      lambda { Compass::Magick::Canvas.new(100, 100) }.should raise_error(Compass::Magick::TypeMismatch)
    end
  end

  subject { Compass::Magick::Canvas.new(Sass::Script::Number.new(100), Sass::Script::Number.new(100)) }

  it "should be transparent" do
    subject.get_pixel(0, 0).should == ChunkyPNG::Color::TRANSPARENT
  end

  it "should encode the image in Base64" do
    subject.to_data_uri.value.include?('data:image/png;base64,').should be_true
  end
end
