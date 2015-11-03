require 'spec_helper'

describe 'Elegant::Document' do
  specify 'does not override the default behavior of Prawn::Document' do
    pdf = Prawn::Document.new
    pdf.move_down 30
    pdf.text 'Hello, world!'
    expect(strings_of pdf.render).not_to be_empty
  end

  specify 'accepts a block with or without an argument' do
    Elegant::Document.new { text 'Hello, world!' }
    Elegant::Document.new {|pdf| pdf.text 'Hello, world!'}
  end

  specify 'accepts some options of Prawn::Document and extra ones' do
    Elegant.configure{|config| config.producer = 'Test Suite'}

    pdf = Elegant::Document.new header: {
      text: 'A report', # text and logo in the top-right corner
      logo: {width: 40, height: 30, url: 'http://lorempixel.com/400/300'},
    }, footer: {
      text: 'A link', # text and link in the bottom-center of the page
      url: 'http://www.example.com',
    }, page_size: 'B5', # will be overwritten to LETTER
    info: {Author: 'RSpec'} # will be merged with metadata configuration

    pdf.title 'Welcome '
    pdf.text 'Hello, world!'
    expect(strings_of pdf.render).not_to be_empty
    # pdf.render_file 'example-elegant.pdf'
  end
end

def strings_of(output)
  PDF::Inspector::Text.analyze(output).strings
end
