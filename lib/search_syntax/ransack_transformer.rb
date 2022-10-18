# frozen_string_literal: true

module SearchSyntax
  class RansackTransformer
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

    def initialize(text:, params:, sort: nil)
      @text = text
      @params = params
      @sort = sort
      @spell_checker = DidYouMean::SpellChecker.new(dictionary: @params)
    end

    def transform_sort_param(value)
      value.split(",").map do |sort_value|
        if sort_value.start_with?("-")
          "#{sort_value[1..]} desc"
        else
          "#{sort_value} asc"
        end
      end
    end

    def transform_with_errors(ast)
      errors = []
      result = {}

      if @params.is_a?(Array)
        ast = ast.filter do |node|
          if node[:type] != :param
            true
          elsif node[:name] == @sort
            result[:s] = transform_sort_param(node[:value])
            false
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
      end.join

      [result, errors]
    end
  end
end
