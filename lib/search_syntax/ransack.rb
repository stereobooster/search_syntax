# frozen_string_literal: true

module SearchSyntax
  class Ransack
    PREDICATES = {
      ">=": :gteq,
      "=>": :gteq,
      "<=": :lteq,
      "=<": :lteq,
      "!=": :not_eq,
      ">": :gt,
      "<": :lt
      # in, not_in, present, blank, null, not_null,
      # matches, does not match, cont, cont_any, cont_all,
      # i_cont..., start, end, true, false, not_true, not_false
    }

    # text - symbol or TODO: callback
    # params - array of symbols or TODO: callback
    def initialize(text:, params:)
      @text = text
      @params = params
    end

    def transform(ast)
      result = {}

      if @params.is_a?(Array)
        ast = ast.filter do |node|
          if node[:type] == :param && @params.include?(node[:name])
            predicate = PREDICATES[node[:predicate]] || :eq
            result["#{node[:name]}_#{predicate}".to_sym] = node[:value]
            false
          else
            true
          end
        end
      end

      result[@text] = ast.map { |node| node[:raw] }.join(" ")
      result
    end
  end
end
