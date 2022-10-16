# frozen_string_literal: true

require "treetop"
Treetop.load "#{__dir__}/search"

module SearchSyntax
  class Parser < ::SearchParser
  end
end
