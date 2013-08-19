# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'unsorted_tree/version'

Gem::Specification.new do |spec|
  spec.name          = 'unsorted_tree'
  spec.version       = UnsortedTree::VERSION
  spec.authors       = ['Tobias Bühlmann', 'Daniel Krüger']
  spec.email         = ['t.buehlmann@thisisdmg.com', 'd.krueger@thisisdmg.com']
  # spec.description   = 'TODO'
  spec.summary       = 'unsorted_tree is a thin gem to abstract unsorted trees through single nodes.'
  spec.homepage      = 'https://github.com/thisisdmg/unsorted_tree'
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split("\n")
  spec.test_files    = spec.files.grep(/^spec/)
  spec.require_paths = ['lib']

  spec.required_ruby_version = '>= 1.9.3'

  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'rake', '~> 10.1'
  spec.add_development_dependency 'rspec', '~> 2.14'
  spec.add_development_dependency 'pry', '>= 0.9.12.2'
end
