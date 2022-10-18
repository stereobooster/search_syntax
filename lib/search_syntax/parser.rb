# frozen_string_literal: true

require "treetop/runtime"
require_relative "search_syntax_grammar"

module SearchSyntax
  class Parser < ::SearchSyntaxGrammarParser
  end
end
