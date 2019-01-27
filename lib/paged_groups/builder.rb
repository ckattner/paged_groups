# frozen_string_literal: true

#
# Copyright (c) 2019-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

module PagedGroups
  # This is the Public API for this library.
  class Builder
    DEFAULT_PAGE_SIZE = 50

    attr_reader :page_size,
                :page_count,
                :row_count,
                :space,
                :spacer

    def initialize(page_size: DEFAULT_PAGE_SIZE, space: false, spacer: nil)
      @page_size  = page_size ? page_size.to_i : DEFAULT_PAGE_SIZE
      @space      = space || false
      @spacer     = spacer

      clear
    end

    def add(*groups, force: false)
      dirty!

      groups.each { |group| insert(Array(group), force: force) }

      self
    end

    def clear
      dirty!

      @pages        = []
      @page_count   = 0
      @current_page = []
      @row_count    = 0
    end

    def all
      return @all if @all

      @all = top? ? @pages : @pages + [@current_page]
    end
    alias to_a all

    def to_s
      "[#{self.class.name}] Page Count: #{page_count}, Row Count: #{row_count}"
    end

    private

    def insert(rows, force: false)
      cut! if start_new_page?(rows) && !force

      space_if_needed

      @current_page += rows

      @row_count += rows.length

      self
    end

    def not_top?
      !top?
    end

    def top?
      @current_page.empty?
    end

    def dirty!
      @all = nil
    end

    def cut!
      @page_count += 1
      @pages << @current_page
      @current_page = []

      nil
    end

    def space_if_needed
      @current_page << spacer if space && not_top?

      nil
    end

    def start_new_page?(next_items)
      proposed_current_page_length = @current_page.length + next_items.length

      not_top? && proposed_current_page_length > page_size
    end

    def end_of_current_page?
      @current_page.length >= page_size
    end
  end
end
