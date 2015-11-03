require 'spec_helper'

describe 'Elegant::Document' do
  specify 'does not override the default behavior of Prawn::Document' do
    pdf = Prawn::Document.new
    pdf.move_down 30
    pdf.text 'Hello, world!'
    expect(strings_of pdf.render).not_to be_empty
    # pdf.render_file 'example-prawn.pdf'
  end

  specify 'includes all the default methods of Prawn::Document' do
    pdf = Elegant::Document.new
    pdf.move_down 30
    pdf.text 'Hello, world!'
    expect(strings_of pdf.render).not_to be_empty
    # pdf.render_file 'example-elegant.pdf'
  end

  specify 'adds more options and methods' do
    Elegant.configure do |config|
      config.author = 'Elegant'
    end
    header = {text: 'A report', logo: {url: 'http://lorempixel.com/500/500'}}
    footer = {text: 'A link', url: 'http://github.com/Fullscreen/elegant'}
    pdf = Elegant::Document.new header: header, footer: footer
    pdf.title 'Welcome'
    pdf.text 'Hello, world!'
    expect(strings_of pdf.render).not_to be_empty
    pdf.render_file 'example-options.pdf'
  end
end

def strings_of(output)
  PDF::Inspector::Text.analyze(output).strings
end
