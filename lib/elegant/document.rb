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
    # Initializes a Document. Some options are fixed (e.g. the size is 612x792),
    # others can be customized through +options+.
    def initialize(options = {})
      super(page_settings info: options[:metadata]) do |document|
        set_fonts document
        render_header document, options.fetch(:header, {})
        yield document if block_given?
        render_footer document, options.fetch(:footer, {})
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

    # Defines the total height occupied by the header
    def header_height
      50
    end

    # Defines the total width occupied by the logo image (top-right corner)
    def logo_width
      @logo_width ||= 0
    end

    # Sets the layout of the page and the PDF metadata.
    def page_settings(options = {})
      options[:page_size] = 'LETTER'
      options[:page_layout] = :portrait
      options[:print_scaling] = :none
      options[:top_margin] = (default = 36) + header_height / 2
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
    def set_fonts(document)
      fonts = Elegant.configuration.fonts.transform_keys{|k| k.to_s.titleize}
      document.font_families.update fonts
      document.fallback_fonts ['Fallback']
    end

    # Draws in the header of each page a watermark logo (provided via the
    # configuration), a horizontal line, a title and an image for the content.
    def render_header(document, options = {})
      document.repeat(:all) do
        render_watermark document
        document.stroke_horizontal_rule
        render_logo document, options[:logo]
        render_heading document, options[:text]
      end
    end

    # Renders a watermark at the top-left corner of each page. The watermark
    # must be provided via configuration.
    def render_watermark(document)
      image = Elegant.configuration.watermark
      height = (header_height * 0.25).ceil
      y = document.bounds.top + (header_height * 0.375).floor
      document.image image, at: [0, y], height: height.ceil
    end

    # Renders an image in the top-right corner of each page. The image must be
    # provided when initializing the document.
    def render_logo(document, logo)
      return unless logo
      url = logo[:url]
      @logo_width = w = logo.fetch :width, 50
      h = logo.fetch :height, 50

      lw = document.line_width
      left = document.bounds.right - w - 1.5 * lw
      top = document.bounds.top + h / 2 + 0.5 * lw
      position = [left + 0.5 * lw, document.bounds.top + h / 2]

      document.float do
        document.bounding_box [left, top], width: w + lw, height: h + lw do
          document.stroke_bounds
        end
        begin
          document.image open(logo[:url]), width: w, height: h, at: position
        rescue OpenURI::HTTPError, OpenSSL::SSL::SSLError, SocketError
        end
      end
    end

    # Writes the heading for the document in the top-right corner of each page,
    # to the left of the logo. The heading must be provided when initializing
    # the document.
    def render_heading(document, text)
      return unless text
      document.transparent(0.25) do
        document.font('Sans Serif', style: :bold) do
          document.text_box text, heading_options(document)
        end
      end
    end
    
    def heading_options(document)
      left = 25
      width = logo_width + 2 * document.line_width + (margin = 5)
      {}.tap do |options|
        options[:valign] = :center
        options[:align] = :right
        options[:overflow] = :shrink_to_fit
        options[:width] = document.bounds.width - width - left
        options[:height] = header_height / 2.0
        options[:size] = 17
        options[:at] = [left, document.bounds.top + options[:height]]
      end
    end

    # Draws in the header of each page a horizontal line, the name of the
    # author, the title and the page number. The author must be provided in
    # the configuration, and the title when initializing the document.
    def render_footer(document, footer)
      text = "<link href='#{footer[:url]}'>#{footer[:text]}</link>"
      left = 50
      options = {size: 7, align: :center, valign: :top, inline_format: true}
      options[:at] = [left, -6]
      options[:width] = document.bounds.width - 2 * left
      options[:height] = 10

      document.repeat(:all) do
        document.transparent(0.25) do
          document.stroke_horizontal_line 0, document.bounds.width, at: 0
        end
        render_author document
        document.text_box text, options
      end
      render_page_number document
    end

    def render_author(document)
      options = {at: [0, -6], width: 50, height: 10, size: 7, valign: :top}
      document.text_box Elegant.configuration.author, options
    end

    def render_page_number(document)
      options = {width: 50, height: 10, size: 7, align: :right, valign: :top}
      options[:at] = [document.bounds.width - options[:width], -6]
      document.number_pages "Page <page>", options
    end
  end
end
