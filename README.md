# paged_groups

[![Gem Version](https://badge.fury.io/rb/paged_groups.svg)](https://badge.fury.io/rb/paged_groups) [![Build Status](https://travis-ci.org/bluemarblepayroll/paged_groups.svg?branch=master)](https://travis-ci.org/bluemarblepayroll/paged_groups) [![Maintainability](https://api.codeclimate.com/v1/badges/905e58c55e1ec9c61383/maintainability)](https://codeclimate.com/github/bluemarblepayroll/paged_groups/maintainability) [![Test Coverage](https://api.codeclimate.com/v1/badges/905e58c55e1ec9c61383/test_coverage)](https://codeclimate.com/github/bluemarblepayroll/paged_groups/test_coverage) [![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

Imagine a two-dimensional data set (first dimension being group and second dimension being record) for which you wanted to page with the following rules:

1. Each page should roughly has the same number of records ([greedy](https://en.wikipedia.org/wiki/Greedy_algorithm))
2. Each group should not be split between pages ([atomic](https://en.wikipedia.org/wiki/Atomicity_(database_systems)))

This library helps you page grouped-data when the grouped data can have different sizes. It provides a builder that understands how to split pages in a fashion where each page tries to conform to a maximum page size but also ensures groups are not split up.

## Installation

To install through Rubygems:

````
gem install install paged_groups
````

You can also add this to your Gemfile:

````
bundle add paged_groups
````

## Examples

### Standard Use-Case

Here is an example data set containing groups with variable number of records:

````ruby
data = [
  [
    { id: 1, name: 'Jordan' },
    { id: 2, name: 'Pippen' },
    { id: 3, name: 'Rodman' },
    { id: 4, name: 'Harper' },
    { id: 5, name: 'Longley' }
  ],
  [
    { id: 6, name: 'Kukoc' }
  ],
  [
    { id: 7, name: 'Kerr' }
  ],
  [
    { id: 8, name: 'Buechler' }
  ],
  [
    { id: 9, name: 'Wennington' },
    { id: 10, name: 'Simpkins' }
  ],
  [
    { id: 11, name: 'Caffey' },
    { id: 12, name: 'Edwards' },
    { id: 13, name: 'Salley' }
  ]
]
````

Let's use max page size of three for this example.  In the real-world a max page size of three is most likely too small but it fits our example data set above for illustration purpose; you should be able to extrapolate this out with larger sets and larger max page sizes.  To page this set we would execute:

````ruby
pages = PagedGroups.builder(page_size: 3).add(data).all
````

*Note:* Add accepts a two-dimensional array with the first dimension being the group and the second dimension being the record.

our ````pages```` variable should now contain a two-dimensional array where dimension one is page and dimension two is record and would be:

````ruby
[
  [
    { id: 1, name: 'Jordan' },
    { id: 2, name: 'Pippen' },
    { id: 3, name: 'Rodman' },
    { id: 4, name: 'Harper' },
    { id: 5, name: 'Longley' }
  ],
  [
    { id: 6, name: 'Kukoc' },
    { id: 7, name: 'Kerr' },
    { id: 8, name: 'Buechler' }
  ],
  [
    { id: 9, name: 'Wennington' },
    { id: 10, name: 'Simpkins' }
  ],
  [
    { id: 11, name: 'Caffey' },
    { id: 12, name: 'Edwards' },
    { id: 13, name: 'Salley' }
  ]
]
````

Notice how each group was kept atomic while each page was tried to be kept as close to the max page size as possible.

### Spacing Customization

There may be merit in placing *separator* record in between groups in the same page.  This separate record can act as a spacer.  You can specify this spacer row in the builder's constructor:

````ruby
pages = PagedGroups.builder(page_size: 3, space: true, spacer: { id: nil, name: '' })
                   .add(data)
                   .all
````

*Note:* ````spacer```` (boolean) argument is split from ````space```` (object) to allow for spacer to be anything (even false or nil.)

Now, our resulting pages would become:

````ruby
[
  [
    { id: 1, name: 'Jordan' },
    { id: 2, name: 'Pippen' },
    { id: 3, name: 'Rodman' },
    { id: 4, name: 'Harper' },
    { id: 5, name: 'Longley' }
  ],
  [
    { id: 6, name: 'Kukoc' },
    { id: nil, name: '' },
    { id: 7, name: 'Kerr' }
  ],
  [
    { id: 8, name: 'Buechler' },
    { id: nil, name: '' },
    { id: 9, name: 'Wennington' },
    { id: 10, name: 'Simpkins' }
  ],
  [
    { id: 11, name: 'Caffey' },
    { id: 12, name: 'Edwards' },
    { id: 13, name: 'Salley' }
  ]
]
````


### Forcing Same Page

Another customization that may come in handy is the ability to force-add groups to the current page.  For example, say we wanted to add another group to our initial data set, but we want it to end up on the same page as the last records:

````ruby
other_data = [
  [
    { id: 14, name: 'Jackson' },
    { id: 14, name: 'Winters' }
  ]
]
pages = PagedGroups.builder(page_size: 3, space: true, spacer: { id: nil, name: '' })
                   .add(data)
                   .add(other_data, force: true)
                   .all
````

*Note:* #add has a [fluent interface](https://en.wikipedia.org/wiki/Fluent_interface) and can be chained as illustrated above.

Now the result pages would be:

````ruby
[
  [
    { id: 1, name: 'Jordan' },
    { id: 2, name: 'Pippen' },
    { id: 3, name: 'Rodman' },
    { id: 4, name: 'Harper' },
    { id: 5, name: 'Longley' }
  ],
  [
    { id: 6, name: 'Kukoc' },
    { id: nil, name: '' },
    { id: 7, name: 'Kerr' }
  ],
  [
    { id: 8, name: 'Buechler' },
    { id: nil, name: '' },
    { id: 9, name: 'Wennington' },
    { id: 10, name: 'Simpkins' }
  ],
  [
    { id: 11, name: 'Caffey' },
    { id: 12, name: 'Edwards' },
    { id: 13, name: 'Salley' },
    { id: nil, name: '' },
    { id: 14, name: 'Jackson' },
    { id: 14, name: 'Winters' }
  ]
]
````

## Contributing

### Development Environment Configuration

Basic steps to take to get this repository compiling:

1. Install [Ruby](https://www.ruby-lang.org/en/documentation/installation/) (check paged_groups.gemspec for versions supported)
2. Install bundler (gem install bundler)
3. Clone the repository (git clone git@github.com:bluemarblepayroll/paged_groups.git)
4. Navigate to the root folder (cd paged_groups)
5. Install dependencies (bundle)

### Running Tests

To execute the test suite run:

````
bundle exec rspec spec --format documentation
````

Alternatively, you can have Guard watch for changes:

````
bundle exec guard
````

Also, do not forget to run Rubocop:

````
bundle exec rubocop
````

### Publishing

Note: ensure you have proper authorization before trying to publish new versions.

After code changes have successfully gone through the Pull Request review process then the following steps should be followed for publishing new versions:

1. Merge Pull Request into master
2. Update [lib/paged_groups/version.rb](https://github.com/bluemarblepayroll/paged_groups/blob/master/lib/paged_groups/version.rb) [version number](https://semver.org/)
3. Bundle
4. Update CHANGELOG.md
5. Commit & Push master to remote and ensure CI builds master successfully
6. Build the project locally: `gem build paged_groups`
7. Publish package to NPM: `gem push paged_groups-X.gem` where X is the version to push
8. Tag master with new version: `git tag <version>`
9. Push tags remotely: `git push origin --tags`

## License

This project is MIT Licensed.
