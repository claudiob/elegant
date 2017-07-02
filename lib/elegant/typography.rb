module Elegant
  # @private
  # An internal class to set the fonts for the document.
  class Typography
    include Prawn::View

    def initialize(document, options = {})
      @document = document
    end
    
    # Set the fonts for the document. Fonts are provided via configuration and
    # a 'Fallback' font must be set to be used for special characters. A
    # 'Sans Serif' font is also required for titles and headers.
    def set_fonts
      font_families.update Elegant.configuration.fonts
      fallback_fonts ['Fallback']
    end
  end
end
