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
      @spell_checker = DidYouMean::SpellChecker.new(dictionary: @params)
    end

    def transform_with_errors(ast)
      errors = []
      result = {}

      if @params.is_a?(Array)
        ast = ast.filter do |node|
          if node[:type] != :param
            true
          elsif @params.include?(node[:name])
            predicate = PREDICATES[node[:predicate]] || :eq
            key = "#{node[:name]}_#{predicate}".to_sym
            if !result.key?(key)
              result[key] = node[:value]
            else
              errors.push(DuplicateParamError.new(
                name: node[:name],
                start: node[:start],
                finish: node[:finish]
              ))
            end
            false
          else
            errors.push(UnknownParamError.new(
              name: node[:name],
              start: node[:start],
              finish: node[:finish],
              did_you_mean: @spell_checker.correct(node[:name])
            ))
            true
          end
        end
      end

      previous = -1
      result[@text] = ast.map do |node|
        separator = previous == node[:start] || previous == -1 ? "" : " "
        previous = node[:finish]
        separator + node[:raw]
      end.join("")

      [result, errors]
    end

    def transform(ast)
      transform_with_errors(ast)[0]
    end
  end
end
