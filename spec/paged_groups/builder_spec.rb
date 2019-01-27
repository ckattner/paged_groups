# frozen_string_literal: true

#
# Copyright (c) 2019-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

require './spec/spec_helper'

describe ::PagedGroups::Builder do
  let(:page_size) { 44 }

  let(:spacer) { 'SPACER' }

  let(:page_builder) do
    ::PagedGroups::Builder.new(page_size: page_size, spacer: spacer, space: true)
  end

  let(:hundred_rows) { Array.new(100) }

  let(:twenty_rows) { Array.new(20) }

  subject { page_builder }

  it { expect(page_builder.page_size).to eq(page_size) }

  describe '#add and #all' do
    it 'should page groups' do
      page_builder.add(hundred_rows)

      expect(page_builder.all.length).to eq(1)

      page_builder.add(twenty_rows)
      page_builder.add(twenty_rows)

      expect(page_builder.all.length).to eq(2)

      page_builder.add(twenty_rows)

      expect(page_builder.all.length).to eq(3)
    end

    it 'should force add and space' do
      page_builder.add(hundred_rows)

      expect(page_builder.all.length).to eq(1)
      expect(page_builder.all.first.length).to eq(100)

      page_builder.add(twenty_rows, force: true)
      page_builder.add(twenty_rows, force: true)

      expect(page_builder.all.length).to eq(1)
      expect(page_builder.all.first.length).to eq(100 + 20 * 2 + 2)

      first_spacer_index = 100
      second_spacer_index = 100 + 20 + 1

      expect(page_builder.all.first[first_spacer_index]).to eq(spacer)
      expect(page_builder.all.first[second_spacer_index]).to eq(spacer)
    end
  end
end
