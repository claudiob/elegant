module Elegant
  # Provides an object to store global configuration settings.
  #
  # This class is typically not used directly, but by calling
  # {Elegant::Config#configure Elegant.configure}, which creates and updates a
  # single instance of {Elegant::Configuration}.
  #
  # @example Set the author of PDF files to 'John Doe':
  #   Elegant.configure do |config|
  #     config.author = 'John Doe'
  #   end
  #
  # @see Elegant::Config for more examples.
  class Configuration
    # @return [String] the Author to store in the PDF metadata
    attr_accessor :author

    # @return [String] the Creator to store in the PDF metadata
    attr_accessor :creator

    # @return [String] the Producer to store in the PDF metadata
    attr_accessor :producer

    # @return [String] the path of an image to display on every page
    attr_accessor :watermark

    # @return [Array<Hash<Symbol, Hash<Symbol, String>] the fonts to use.
    attr_accessor :fonts

    def initialize
      self.author = 'Elegant'
      self.creator = 'Elegant'
      self.producer = 'Elegant'
      self.watermark = File.expand_path '../images/watermark.png', __FILE__
      self.fonts = {
        sans_serif: font_for('DejaVuSans'), 
        fallback: font_for('DejaVuSans')
      }
    end

  private

    def font_for(family)
      {
        normal: File.expand_path("../fonts/#{family}.ttf", __FILE__),
        bold: File.expand_path("../fonts/#{family}-Bold.ttf", __FILE__),
      }
    end
  end
end
