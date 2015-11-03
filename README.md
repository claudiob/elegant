Elegant
=======

Elegant provides a nice layout for PDF reports generated in Ruby.

The **source code** is available on [GitHub](https://github.com/Fullscreen/elegant) and the **documentation** on [RubyDoc](http://www.rubydoc.info/github/Fullscreen/elegant/master/Elegant/Interface).

[![Build Status](http://img.shields.io/travis/Fullscreen/elegant/master.svg)](https://travis-ci.org/Fullscreen/elegant)
[![Coverage Status](http://img.shields.io/coveralls/Fullscreen/elegant/master.svg)](https://coveralls.io/r/Fullscreen/elegant)
[![Dependency Status](http://img.shields.io/gemnasium/Fullscreen/elegant.svg)](https://gemnasium.com/Fullscreen/elegant)
[![Code Climate](http://img.shields.io/codeclimate/github/Fullscreen/elegant.svg)](https://codeclimate.com/github/Fullscreen/elegant)
[![Online docs](http://img.shields.io/badge/docs-✓-green.svg)](http://www.rubydoc.info/github/Fullscreen/elegant/master/Elegant)
[![Gem Version](http://img.shields.io/gem/v/elegant.svg)](http://rubygems.org/gems/elegant)

Elegant is a library built on top of [Prawn](http://prawnpdf.org) to generate PDF files in Ruby.

Whereas Prawn creates PDF pages that are completely blank (letting users customize them at will),
Elegant comes with a nice layout that makes each page look… elegant! :wink:

How to use
==========

If you have never used [Prawn](http://prawnpdf.org/) to generate PDF files, you should first read [its manual](http://prawnpdf.org/manual.pdf).

Using Elegant is as simple as replacing any instance of `Prawn::Document` with `Elegant::Document`:

```ruby
# with Prawn
Prawn::Document.new do
  text 'Hello, World!'
end

# with Elegant
Elegant::Document.new do
  text 'Hello, World!'
end

# with Elegant and extra options
header = {text: 'A report', logo: {url: 'http://lorempixel.com/500/500'}}
footer = {text: 'A link', url: 'http://www.example.com'}
Elegant::Document.new(header: header, footer: footer) do
  title 'Welcome'
  text 'Hello, world!'
end
```

![Prawn vs. Elegant](https://cloud.githubusercontent.com/assets/7408595/10898333/433a6072-817e-11e5-8c95-999c5629e84c.jpg)

`Elegant::Document` accepts some options [... TODO ...]

How to install
==============

Elegant requires **Ruby 2.1 or higher**.

To include in your project, add `gem 'elegant', ~> '1.0'` to the `Gemfile` file of your Ruby project.

How to generate the manual
==========================

`rake manual`

How to contribute
=================

If you’ve made it this far in the README… thanks! :v:
Feel free to try it the gem, explore the code, and send issues or pull requests.

All pull requests will have to make Travis and Code Climate happy in order to be accepted. :kissing_smiling_eyes:

You can also run the tests locally with `bundle exec rspec`.

Happy hacking!
