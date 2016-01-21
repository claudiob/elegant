require 'open-uri' # for open(http://...)
module Elegant
  class Footer
    include Prawn::View

    def initialize(document, options = {})
      @document = document
      @text = options[:text]
    end

    # Draws in the header of each page a horizontal line, the name of the
    # author, the title and the page number. The author must be provided in
    # the configuration, and the title when initializing the document.
    def render
      repeat(:all) do
        transparent(0.25) { stroke_horizontal_line 0, bounds.width, at: 0 }
        render_author
        render_text if @text
      end
      render_page_number
    end

  private

    def render_author
      options = {at: [0, -6], width: 50, height: 10, size: 7, valign: :top}
      text_box Elegant.configuration.author, options
    end

    def render_text
      left = 50
      options = {size: 7, align: :center, valign: :top, inline_format: true}
      options[:at] = [left, -6]
      options[:width] = bounds.width - 2 * left
      options[:height] = 10
      text_box @text, options
    end

    def render_page_number
      options = {width: 50, height: 10, size: 7, align: :right, valign: :top}
      options[:at] = [bounds.width - options[:width], -6]
      number_pages "Page <page>", options
    end
  end
end
