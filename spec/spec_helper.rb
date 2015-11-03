require 'simplecov'
require 'coveralls'

SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
  SimpleCov::Formatter::HTMLFormatter,
  Coveralls::SimpleCov::Formatter
]
SimpleCov.start

Dir['./spec/support/**/*.rb'].each {|f| require f}

RSpec.configure do |config|
  config.order = 'random'
  config.run_all_when_everything_filtered = false
end

require 'pdf/inspector'
require 'elegant'

# RSpec.shared_context 'Factories', factories: true do
#   let(:uniques) { {2013 => 45, 2014 => 80, 2015 => 12} }
#   let(:views) { {2013 => 182432, 2014 => 46567, 2015 => 102945} }
# end
# 
# RSpec.shared_context 'PDF Inspector', inspect: true do
#   let(:pdf) { Prawn::Document.new }
#   let(:output) { pdf.render }
#   let(:inspected_line) { PDF::Inspector::Graphics::Line.analyze output }
#   let(:inspected_points) { inspected_line.points.each_slice(2) }
#   let(:inspected_text) { PDF::Inspector::Text.analyze output }
#   let(:inspected_strings) { inspected_text.strings }
#   let(:inspected_rectangle) { PDF::Inspector::Graphics::Rectangle.analyze output }
#   let(:inspected_rectangles) { inspected_rectangle.rectangles }
#   let(:inspected_color) { PDF::Inspector::Graphics::Color.analyze output }
#   let(:inspected_curve) { PDF::Inspector::Graphics::Curve.analyze output }
#   let(:inspected_coords) { inspected_curve.coords }
#   let(:options) { {} }
# 
# 
#   # let(:views) { {2013 => 182, 2014 => 46, 2015 => 102} }
#   # let(:uniques) { {2013 => 110, 2014 => 30, 2015 => 88} }
#   # let(:no_series) { {} }
#   # let(:one_series) { {views: views} }
#   # let(:two_series) { {views: views, uniques: uniques} }
# end
# 
# # Monkey-patch so non-black colors can be analyzed at the end
# class PDF::Inspector::Graphics::Color
#   def set_color_for_nonstroking_and_special(*params)
#     @fill_color = params unless params.all? &:zero?
#   end
# end
