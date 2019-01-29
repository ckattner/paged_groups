# frozen_string_literal: true

#
# Copyright (c) 2019-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

require './spec/spec_helper'

describe ::PagedGroups do
  describe 'README examples' do
    let(:data) do
      [
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
    end

    let(:page_size) { 3 }

    let(:spacer) { { id: nil, name: '' } }

    specify 'Standard use-case example works as advertised' do
      pages = PagedGroups.builder(page_size: page_size).add(data).all

      expected_pages = [
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

      expect(pages).to eq(expected_pages)
    end

    specify 'Spacing customization example works as advertised' do
      pages = PagedGroups.builder(page_size: page_size, space: true, spacer: spacer)
                         .add(data)
                         .all

      expected_pages = [
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

      expect(pages).to eq(expected_pages)
    end

    specify 'Forcing same page example works as advertised' do
      other_data = [
        [
          { id: 14, name: 'Jackson' },
          { id: 14, name: 'Winters' }
        ]
      ]

      pages = PagedGroups.builder(page_size: page_size, space: true, spacer: spacer)
                         .add(data)
                         .add(other_data, force: true)
                         .all

      expected_pages = [
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

      expect(pages).to eq(expected_pages)
    end
  end
end
