lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'elegant/version'

Gem::Specification.new do |spec|
  spec.name          = 'elegant'
  spec.version       = Elegant::VERSION
  spec.authors       = ['claudiob']
  spec.email         = ['claudiob@gmail.com']

  spec.summary       = %q{An elegant layout for PDF reports generated in Ruby.}
  spec.description   = %q{Elegant expands Prawn providing a new class to generate new pages with an elegant layout.}
  spec.homepage      = 'https://github.com/Fullscreen/elegant'
  spec.license       = 'MIT'

  spec.required_ruby_version = '>= 2.1' # 2.0 does not have Array#to_h

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency             'prawn', '~> 2.0'
  spec.add_dependency             'activesupport', '~> 4.0'
  spec.add_development_dependency 'pdf-inspector', '~> 1.2'
  spec.add_development_dependency 'prawn-manual_builder', '~> 0.2.0'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.3'
  spec.add_development_dependency 'coveralls', '~> 0.8.2'
  spec.add_development_dependency 'pry-nav', '~> 0.2.4'
end
