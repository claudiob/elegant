require 'open-uri' # for open(http://...)
module Elegant
  # Provides a uniform footer for each document containing the author in the
  # left side, an optional text in the middle, the page number in the right
  # side and a horizontal line to separate the footer from the rest of the page.
  #
  # This class is typically not used directly, but by calling
  # {Elegant::Document#initialize Elegant::Document.new} with a footer option.
  #
  # @example Set the footer text to 'Hello World' on each page:
  #   Elegant::Document.new footer: {text: 'Hello World'}
  class Footer
    include Prawn::View

    # Creates a new Elegant Headers.
    # @param [Elegant::Documnet] document the document to apply to header to.
    # @param [Hash] options the options to change the aspect of the footer.
    # @option options [String] :text the text to display in the center of the
    #   footer.
    def initialize(document, options = {})
      @document = document
      @text = options[:text]
    end

    # Displays a footer in each page of the document which includes the author,
    # an optional text, the page number and a horizontal line.
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
