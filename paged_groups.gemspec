# frozen_string_literal: true

require './lib/paged_groups/version'

Gem::Specification.new do |s|
  s.name        = 'paged_groups'
  s.version     = PagedGroups::VERSION
  s.summary     = 'Create an evenly paged dataset of un-evenly sized groups'

  s.description = <<-DESCRIPTION
    This library helps you page grouped-data when the grouped data can have different sizes.
    It provides a builder that understands how to split pages in a fashion where each page tries to
    conform to a maximum page size (greedy) but also ensures groups are not split up (atomic.)
  DESCRIPTION

  s.authors     = ['Matthew Ruggio']
  s.email       = ['mruggio@bluemarblepayroll.com']
  s.files       = `git ls-files`.split("\n")
  s.test_files  = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables = `git ls-files -- bin/*`.split("\n").map { |f| File.basename(f) }
  s.homepage    = 'https://github.com/bluemarblepayroll/paged_groups'
  s.license     = 'MIT'

  s.required_ruby_version = '>= 2.3.8'

  s.add_development_dependency('guard-rspec', '~>4.7')
  s.add_development_dependency('rspec', '~> 3.8')
  s.add_development_dependency('rubocop', '~>0.63.1')
  s.add_development_dependency('simplecov', '~>0.16.1')
  s.add_development_dependency('simplecov-console', '~>0.4.2')
end
