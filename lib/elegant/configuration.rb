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
      @author = 'Elegant'
      @creator = 'Elegant'
      @producer = 'Elegant'
      @watermark = asset 'images/default_watermark.png'
      @fonts = {sans_serif: font('DejaVuSans'), fallback: font('DejaVuSans')}
    end

  private

    def font(type)
      {normal: asset("fonts/#{type}.ttf"), bold: asset("fonts/#{type}Bold.ttf")}
    end
    
    def asset(file)
      File.expand_path "../#{file}", __FILE__
    end
  end
end
