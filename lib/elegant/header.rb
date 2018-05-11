require 'open-uri' # for open(http://...)
module Elegant
  # Provides a uniform header for each document containing a small watermark
  # image in the left side, room for an optional grey heading text in the right
  # side, room for an optional framed logo in the right side and a horizontal
  # line to separate the header from the rest of the page.
  #
  # This class is typically not used directly, but by calling
  # {Elegant::Document#initialize Elegant::Document.new} with a header option.
  #
  # @example Set the heading text to 'Hello World' on each page:
  #   Elegant::Document.new header: {text: 'Hello World'}
  class Header
    include Prawn::View

    # Creates a new Elegant Headers.
    # @param [Elegant::Documnet] document the document to apply to header to.
    # @param [Hash] options the options to change the aspect of the header.
    # @option options [String] :text the text to display in the right side.
    # @option options [Hash] :logo the properties of the logo to display in the
    #  right side. Valid properties are `:url` (a string with the
    #  URL of the logo image), `:width` and `:height` (integer specifying the
    #  width and height of the logo, default to 50).
    def initialize(document, options = {})
      @document = document
      @text, @logo = options.values_at :text, :logo
      @logo_width = @logo.fetch(:width, 50) if @logo
      @logo_height = @logo.fetch(:height, 50) if @logo
    end

    # Displays a header in each page of the document which includes a watermark
    # image, optional heading and logo, and a horizontal line.
    def render
      render_watermark
      stroke_horizontal_rule
      render_logo
      render_heading
    end

    # Sets the right padding for title based on whether the page has a logo
    # or not.
    def title_padding
      @logo_width ? @logo_width + (margin = 7) : 0
    end

  private

    # Renders a watermark at the top-left corner of each page. The watermark
    # must be provided via configuration.
    def render_watermark
      image = Elegant.configuration.watermark
      height = (document.header_height * 0.25).ceil
      y = bounds.top + (document.header_height * 0.375).floor
      image image, at: [0, y], height: height.ceil
    end


    # Renders an image in the top-right corner of each page. The image must be
    # provided when initializing the document.
    def render_logo
      float do
        render_logo_frame
        render_logo_image if @logo[:url]
      end if @logo
    end

    # Renders a frame around the logo in the top-right corner.
    def render_logo_frame(options = {})
      width = @logo_width + line_width
      height = @logo_height + line_width
      left = bounds.right - width - 0.5 * line_width
      top = bounds.top + 0.5 * height
      bounding_box([left, top], width: width, height: height) do
        old_color = self.fill_color
        fill_color 'FFFFFF'
        fill_rectangle [0, height], width, height
        fill_color old_color
        stroke_bounds
      end
    end

    # Renders the actual image as the logo in the top-right corner.
    def render_logo_image
      left = bounds.right - @logo_width - line_width
      top = bounds.top + @logo_height / 2
      options = {width: @logo_width, height: @logo_height, at: [left, top]}
      image open(@logo[:url]), options
    rescue OpenURI::HTTPError, OpenSSL::SSL::SSLError, SocketError, Prawn::Errors::UnsupportedImageType
    end

    # Writes the heading for the document in the top-right corner of each page,
    # to the left of the logo. The heading must be provided when initializing
    # the document.
    def render_heading
      transparent(0.25) do
        font('Sans Serif', style: :bold) {text_box @text, heading_options}
      end if @text
    end

    def heading_options(options = {})
      left = 25
      width = (@logo_width || 0) + 2 * line_width + (margin = 5)
      options[:valign] = :center
      options[:align] = :right
      options[:size] = 17
      options[:overflow] = :shrink_to_fit
      options[:width] = bounds.width - width - left
      options[:height] = document.header_height / 2.0
      options[:at] = [left, bounds.top + options[:height]]
      options
    end
  end
end
