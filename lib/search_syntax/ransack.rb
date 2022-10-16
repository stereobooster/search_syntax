# frozen_string_literal: true

module SearchSyntax
  class Ransack
    # text - symbol or callback
    # params - array of symbols or callback
    def initialize(text:, params:)
      @text = text
      @params = params
    end

    def transform(ast)
      result = {}

      if @params.is_a?(Array)
        ast = ast.filter do |node|
          if node[:type] == :param && @params.include?(node[:name])
            predicate, value = Ransack.detect_predicate(node[:value])
            result["#{node[:name]}#{predicate}".to_sym] = value
            false
          else
            true
          end
        end
      end

      result[@text] = ast.map { |node| node[:raw] }.join(" ")
      result
    end

    # shall it be in the parser?
    # Other predicates: in, not_in,
    # matches, does not match, cont, cont_any, cont_all
    # i_cont..., start, end, true, false, not_true, not_false
    # present, blank, null, not_null
    def self.detect_predicate(v)
      if v.start_with?(">=", "=>")
        ["_gteq", v[2...v.length]]
      elsif v.start_with?("<=", "=<")
        ["_lteq", v[2...v.length]]
      elsif v.start_with?(">")
        ["_gt", v[1...v.length]]
      elsif v.start_with?("<")
        ["_lt", v[1...v.length]]
      elsif v.start_with?("!=")
        ["_not_eq", v[2...v.length]]
      else
        ["_eq", v]
      end
    end
  end
end
