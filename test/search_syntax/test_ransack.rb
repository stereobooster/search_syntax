# frozen_string_literal: true

require "test_helper"

class TestAdvancedSearchRansack < Minitest::Test
  def setup
    @transformer = SearchSyntax::Ransack.new(text: :title_cont, params: ["param"])
    @parser = SearchSyntax::Parser.new
  end

  # def assert_transform(ast, query)
  #   assert_equal @transformer.transform(ast), query
  # end

  def assert_parse_transform(text, query, error = [])
    query_res, error_res = @transformer.transform_with_errors(@parser.parse(text).value)
    assert_equal query_res, query
    assert_equal error_res.map(&:message), error
  end

  def test_text
    assert_parse_transform "text search",
      {title_cont: "text search"}
  end

  def test_basic_param
    assert_parse_transform "param:1",
      {title_cont: "", param_eq: "1"}
  end

  def test_predicates
    assert_parse_transform "param:>1",
      {title_cont: "", param_gt: "1"}

    assert_parse_transform "param:<1",
      {title_cont: "", param_lt: "1"}

    assert_parse_transform "param:>=1",
      {title_cont: "", param_gteq: "1"}

    assert_parse_transform "param:=>1",
      {title_cont: "", param_gteq: "1"}

    assert_parse_transform "param:<=1",
      {title_cont: "", param_lteq: "1"}

    assert_parse_transform "param:=<1",
      {title_cont: "", param_lteq: "1"}

    assert_parse_transform "param:!=1",
      {title_cont: "", param_not_eq: "1"}
  end

  def test_absent_param
    assert_parse_transform "paramx:1",
      {title_cont: "paramx:1"},
      ["Unknown parameter 'paramx' at position 0. Did you mean 'param'?"]
  end

  def test_sort_param
    skip # TODO:

    assert_parse_transform "sort:-created_at",
      {title_cont: "", s: "created_at desc"}

    assert_parse_transform "sort:-created_at,updated_at",
      {title_cont: "", s: ["created_at desc", "updated_at asc"]}
  end

  def test_duplicate_param
    assert_parse_transform "param:1 param:2",
      {title_cont: "", param_eq: "1"},
      ["Duplicate parameter 'param' at position 8."]

    assert_parse_transform "title_cont:1",
      {title_cont: "title_cont:1"},
      ["Unknown parameter 'title_cont' at position 0."]

    # similar to param:1..2
    assert_parse_transform "param:>=1 param:<=2",
      {param_gteq: "1", param_lteq: "2", title_cont: ""}
  end

  def test_issue_1
    skip "TODO: print back the same string"
    # use CST instead of AST
    assert_parse_transform '"xxx"yyy',
      {title_cont: '"xxx"yyy'}
  end

  def test_issue_2
    assert_parse_transform 'param:">"',
      {title_cont: "", param_eq: ">"}
  end

  def test_issue_3
    assert_parse_transform 'param:>"a b"',
      {title_cont: "", param_gt: "a b"}
  end

  def test_issue_4
    assert_parse_transform 'param:O"neil',
      {title_cont: "", param_eq: 'O"neil'}

    assert_parse_transform 'param:"O\"neil"',
      {title_cont: "", param_eq: "O\"neil"}
  end
end
