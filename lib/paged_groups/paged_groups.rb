# frozen_string_literal: true

#
# Copyright (c) 2019-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

require_relative 'builder'

# Top-level namespace for primary public API.
module PagedGroups
  class << self
    # This is syntactic sugar and is equivalent to: PagedGroups::Builder.new(args)
    # Check the constructor signature of PagedGroups::Builder for argument definition.
    def builder(*args)
      ::PagedGroups::Builder.new(*args)
    end
  end
end
