require 'active_support'
require 'active_support/core_ext/hash/except' # for Hash#except
# require 'active_support/core_ext/string/inflections' # for titleize/camelize
# require 'active_support/core_ext/hash/keys' # for transform_keys!
# require 'open-uri'

require 'elegant/config'
require 'elegant/footer'
require 'elegant/header'
require 'elegant/typography'


module Elegant
  # A wrapper around Prawn::Document that enforces an elegant layout, setting
  # nice dimensions and margins so that each page can fit up to three sections
  # of content properly aligned along the vertical axis.
  class Document < ::Prawn::Document
    # Creates a new Elegant Document.
    # @param [Hash] options. All the options of Prawn::Document are
    # available, plus the following extra options.
    # @option options [Hash] :header ({}) The options for the header. Accepted
    #   values are :text (the title to write in the top-right corner) and :logo
    #   (a Hash with a :url key with the location of the logo image and
    #    optional :width and :height, which default to 50x50).
    # @option options [Hash] :footer ({}) The options for the footer. Accepted
    #   values are :text (the text in the bottom-center of the page) and :url
    #   (to make that text a link to a URL).
    # @see http://www.rubydoc.info/gems/prawn/Prawn/Document
    def initialize(options = {}, &block)
      @header = Header.new self, options.fetch(:header, {})
      @footer = Footer.new self, options.fetch(:footer, {})

      super(with_elegant options.except(:header, :footer)) do
        Typography.new(self).set_fonts
        @header.render

        if block
          block.arity < 1 ? instance_eval(&block) : block[self]
        end

        @footer.render
      end
    end

    # An additional method provided by Elegant::Document to render a title
    # with an elegant font and padding above and below.
    def title(text, options = {})
      move_down 10

      width = bounds.width - @header.title_padding
      title = text_options.merge text: text.upcase, color: '556270', size: 14
      options = {width: width, height: 15, at: [0, cursor]}
      formatted_text_box [title], options

      move_down 30
    end

    # Determines the total height occupied by the header
    def header_height
      50
    end

  private

    # Applies some elegant defaults to the options provided by the user. For
    # instance forces the layout to be letter portrait, and set the metadata
    # from the configuration if not explicitly provided.
    def with_elegant(options)
      options[:page_size] = 'LETTER'
      options[:page_layout] = :portrait
      options[:print_scaling] = :none
      options[:top_margin] = (default_margin = 36) + header_height / 2
      options[:info] = default_metadata.merge(options.fetch :info, {})
      options
    end

    def default_metadata
      %i(Author Creator Producer).map do |key|
        [key, Elegant.configuration.public_send(key.to_s.downcase)]
      end.to_h
    end

    def text_options
      {font: 'Sans Serif', styles: [:bold]}
    end
  end
end
