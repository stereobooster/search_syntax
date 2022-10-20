# frozen_string_literal: true

require "test_helper"

class TestAdvancedSearchRansack < Minitest::Test
  def setup
    @parser = SearchSyntax::Ransack.new(text: :title_cont, params: ["param"], sort: "sort")
  end

  def assert_parse(text, query, errors = [])
    query_res, error_res = @parser.parse_with_errors(text)
    assert_equal query_res, query
    assert_equal error_res.map(&:message), errors
  end

  def test_empty
    assert_parse "", {title_cont: ""}

    assert_parse nil, {title_cont: ""}
  end

  def test_text
    assert_parse "text search",
      {title_cont: "text search"}
  end

  def test_basic_param
    assert_parse "param:1",
      {title_cont: "", param_eq: "1"}
  end

  def test_predicates
    assert_parse "param:>1",
      {title_cont: "", param_gt: "1"}

    assert_parse "param:<1",
      {title_cont: "", param_lt: "1"}

    assert_parse "param:>=1",
      {title_cont: "", param_gteq: "1"}

    assert_parse "param:=>1",
      {title_cont: "", param_gteq: "1"}

    assert_parse "param:<=1",
      {title_cont: "", param_lteq: "1"}

    assert_parse "param:=<1",
      {title_cont: "", param_lteq: "1"}

    assert_parse "param:!=1",
      {title_cont: "", param_not_eq: "1"}
  end

  def test_absent_param
    assert_parse "paramx:1",
      {title_cont: "paramx:1"},
      ["Unknown parameter 'paramx' at position 0. Did you mean 'param'?"]
  end

  def test_sort_param
    assert_parse "sort:-created_at",
      {title_cont: "", s: ["created_at desc"]}

    assert_parse "sort:-created_at,updated_at",
      {title_cont: "", s: ["created_at desc", "updated_at asc"]}
  end

  def test_duplicate_param
    assert_parse "param:1 param:2",
      {title_cont: "", param_eq: "1"},
      ["Duplicate parameter 'param' at position 8."]

    assert_parse "title_cont:1",
      {title_cont: "title_cont:1"},
      ["Unknown parameter 'title_cont' at position 0."]

    # similar to param:1..2
    assert_parse "param:>=1 param:<=2",
      {param_gteq: "1", param_lteq: "2", title_cont: ""}
  end

  def test_issue_1
    assert_parse '"xxx"yyy',
      {title_cont: '"xxx"yyy'}
  end

  def test_issue_2
    assert_parse 'param:">"',
      {title_cont: "", param_eq: ">"}
  end

  def test_issue_3
    assert_parse 'param:>"a b"',
      {title_cont: "", param_gt: "a b"}
  end

  def test_issue_4
    assert_parse 'param:O"neil',
      {title_cont: "", param_eq: 'O"neil'}

    assert_parse 'param:"O\"neil"',
      {title_cont: "", param_eq: "O\"neil"}
  end

  def test_param_rename
    parser = SearchSyntax::Ransack.new(text: :title_cont, params: {param: "db_column"})
    query_res = parser.parse("param:1")
    assert_equal query_res, {title_cont: "", db_column_eq: "1"}
  end
end
