require 'active_support'
require 'active_support/core_ext/string/inflections' # for titleize/camelize
require 'active_support/core_ext/hash/keys' # for transform_keys!
require 'open-uri'
require 'elegant/config'

module Elegant
  # A wrapper around Prawn::Document that enforces an elegant layout, setting
  # nice dimensions and margins so that each page can fit up to three sections
  # of content properly aligned along the vertical axis.
  class Document < ::Prawn::Document
    HEADER_HEIGHT =  50 # total height occupied by the header

    # Initializes a Document. Some options are fixed (e.g. the size is 612x792),
    # others can be customized through +options+.
    def initialize(options = {})
      super(page_settings info: options[:metadata]) do
        set_fonts
        render_header options.fetch(:header, {})
        yield if block_given?
        render_footer options.fetch(:footer, {})
      end
    end

    def title(text, options = {})
      move_down 10
      text = {text: text.upcase, font: 'Sans Serif', overflow: :shrink_to_fit,
        styles: [:bold], valign: :center, color: '556270', size: 14}
      options = {inline_format: true, at: [0, cursor], height: 15,
        width: bounds.width - (margin = 7) - logo_width}
      formatted_text_box [text], options
      move_down 30
    end

  private

    # Defines the total width occupied by the logo image (top-right corner)
    def logo_width
      @logo_width ||= 0
    end

    # Sets the layout of the page and the PDF metadata.
    def page_settings(options = {})
      options[:page_size] = 'LETTER'
      options[:page_layout] = :portrait
      options[:print_scaling] = :none
      options[:top_margin] = (default = 36) + HEADER_HEIGHT / 2
      options[:info] ||= {}
      options[:info].merge!(default_metadata).transform_keys! do |key|
        key.to_s.camelize.to_sym
      end
      options
    end

    # Parses some PDF metadata from the configuration.
    def default_metadata
      %i(author creator producer).map do |key|
        [key, Elegant.configuration.public_send(key)]
      end.to_h
    end

    # Set the fonts for the document. Fonts are provided via configuration and
    # a 'Fallback' font must be set to be used for special characters. A
    # 'Sans Serif' font is also required for titles and headers.
    def set_fonts
      fonts = Elegant.configuration.fonts.transform_keys{|k| k.to_s.titleize}
      font_families.update fonts
      fallback_fonts ['Fallback']
    end

    # Draws in the header of each page a watermark logo (provided via the
    # configuration), a horizontal line, a title and an image for the content.
    def render_header(options = {})
      repeat(:all) do
        render_watermark
        stroke_horizontal_rule
        render_logo options[:logo]
        render_heading options[:text]
      end
    end

    # Renders a watermark at the top-left corner of each page. The watermark
    # must be provided via configuration.
    def render_watermark
      image = Elegant.configuration.watermark
      height = (HEADER_HEIGHT * 0.25).ceil
      y = bounds.top + (HEADER_HEIGHT * 0.375).floor
      image image, at: [0, y], height: height.ceil
    end

    # Renders an image in the top-right corner of each page. The image must be
    # provided when initializing the document.
    def render_logo(options)
      float do
        render_logo_frame options
        render_logo_image options
      end if options
    end

    # Renders a frame around the logo in the top-right corner.
    def render_logo_frame(options = {})
      w = options.fetch(:width, 50) + line_width
      h = options.fetch(:height, 50) + line_width
      left = bounds.right - w - 0.5 * line_width
      top = bounds.top + h * 0.5
      bounding_box([left, top], width: w, height: h) {stroke_bounds}
    end

    # Renders the actual image as the logo in the top-right corner.
    def render_logo_image(options)
      w = @logo_width = options.fetch :width, 50
      h = options.fetch :height, 50
      position = [bounds.right - w - line_width, bounds.top + h / 2]
      image open(options[:url]), width: w, height: h, at: position
    rescue OpenURI::HTTPError, OpenSSL::SSL::SSLError, SocketError
    end

    # Writes the heading for the document in the top-right corner of each page,
    # to the left of the logo. The heading must be provided when initializing
    # the document.
    def render_heading(text)
      transparent(0.25) do
        font('Sans Serif', style: :bold) {text_box text, heading_options}
      end if text
    end

    def heading_options(options = {})
      left = 25
      width = logo_width + 2 * line_width + (margin = 5)
      options[:valign] = :center
      options[:align] = :right
      options[:size] = 17
      options[:overflow] = :shrink_to_fit
      options[:width] = bounds.width - width - left
      options[:height] = HEADER_HEIGHT / 2.0
      options[:at] = [left, bounds.top + options[:height]]
      options
    end

    # Draws in the header of each page a horizontal line, the name of the
    # author, the title and the page number. The author must be provided in
    # the configuration, and the title when initializing the document.
    def render_footer(footer)
      text = "<link href='#{footer[:url]}'>#{footer[:text]}</link>"
      left = 50
      options = {size: 7, align: :center, valign: :top, inline_format: true}
      options[:at] = [left, -6]
      options[:width] = bounds.width - 2 * left
      options[:height] = 10

      repeat(:all) do
        transparent(0.25) do
          stroke_horizontal_line 0, bounds.width, at: 0
        end
        settings = {at: [0, -6], width: 50, height: 10, size: 7, valign: :top}
        text_box Elegant.configuration.author, settings

        text_box text, options
      end
      render_page_number
    end

    def render_page_number
      options = {width: 50, height: 10, size: 7, align: :right, valign: :top}
      options[:at] = [bounds.width - options[:width], -6]
      number_pages "Page <page>", options
    end
  end
end
