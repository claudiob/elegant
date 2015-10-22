require 'elegant/configuration'

module Elegant
  # Provides methods to read and write global configuration settings.
  #
  # @example Set the author of PDF files to 'John Doe':
  #   Elegant.configure do |config|
  #     config.author = 'John Doe'
  #   end
  #
  module Config
    # Yields the global configuration to the given block.
    #
    # @example
    #   Elegant.configure do |config|
    #     config.author = 'John Doe'
    #   end
    #
    # @yield [Elegant::Configuration] The global configuration.
    def configure
      yield configuration if block_given?
    end

    # Returns the global {Elegant::Models::Configuration} object.
    #
    # While this method _can_ be used to read and write configuration settings,
    # it is easier to use {Elegant::Config#configure} Elegant.configure}.
    #
    # @example
    #     Elegant.configuration.author = 'John Doe'
    #
    # @return [Elegant::Configuration] The global configuration.
    def configuration
      @configuration ||= Elegant::Configuration.new
    end
  end

  # @note Config is the only module auto-loaded in the Elegant module,
  #       in order to have a syntax as easy as Elegant.configure

  extend Config
end
