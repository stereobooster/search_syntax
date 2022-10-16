# frozen_string_literal: true

require "test_helper"

# do we need parencies?
# do we need `OR`?
# do we need negation operator (`-`)?
class TestAdvancedSearchParser < Minitest::Test
  def setup
    @parser = SearchSyntax::Parser.new
  end

  def assert_parse(text, *ast)
    assert_equal @parser.parse(text).value, ast
  end

  def test_basic_search
    assert_parse "text search",
      {type: :bare, value: "text", raw: "text"},
      {type: :bare, value: "search", raw: "search"}
  end

  def test_ignores_spaces_and_tabs
    assert_parse "  text \t search   ",
      {type: :bare, value: "text", raw: "text"},
      {type: :bare, value: "search", raw: "search"}
  end

  def test_quoted_text_single
    assert_parse "'  text \t search   '",
      {type: :quoted, value: "  text \t search   ", raw: "'  text \t search   '"}
  end

  def test_quoted_text_double
    assert_parse "\"  text \t search   \"",
      {type: :quoted, value: "  text \t search   ", raw: "\"  text \t search   \""}
  end

  def test_eacape_character
    skip "TODO: fix this"
    assert_parse "'\\''",
      {type: :quoted, value: "\\'", raw: "'\\''"}
  end

  def test_broken_quotes
    assert_parse "'test",
      {type: :bare, value: "'test", raw: "'test"}

    # shall it recognize quotes here?
    assert_parse "t'test'",
      {type: :bare, value: "t'test'", raw: "t'test'"}

    # but it recognizes it here
    assert_parse "'test't",
      {type: :quoted, value: "test", raw: "'test'"},
      {type: :bare, value: "t", raw: "t"}

    assert_parse "'''",
      {type: :quoted, value: "", raw: "''"},
      {type: :bare, value: "'", raw: "'"}
  end

  def test_param
    assert_parse "param:1",
      {type: :param, name: "param", value: "1", raw: "param:1"}
  end

  def test_param_quoted_value
    assert_parse "param:'1 2'",
      {type: :param, name: "param", value: "1 2", raw: "param:'1 2'"}
  end

  def test_quotes_before_params
    assert_parse "'param:1'",
      {type: :quoted, value: "param:1", raw: "'param:1'"}

    # this is most likely an error in user input
    assert_parse "'param:1",
      {type: :param, name: "'param", value: "1", raw: "'param:1"}

    assert_parse "param':1",
      {type: :param, name: "param'", value: "1", raw: "param':1"}

    # shall it support quoted params?
    assert_parse "'param':1",
      {type: :quoted, value: "param", raw: "'param'"}, {type: :bare, value: ":1", raw: ":1"}
  end

  def test_strange_strings
    assert_parse "\n",
      {type: :bare, value: "\n", raw: "\n"}

    assert_parse "🤷‍♀️:1",
      {type: :param, name: "🤷‍♀️", value: "1", raw: "🤷‍♀️:1"}
  end
end
