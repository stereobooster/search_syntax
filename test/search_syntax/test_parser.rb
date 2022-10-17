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
      {type: :bare, value: "text", raw: "text", start: 0, finish: 4},
      {type: :bare, value: "search", raw: "search", start: 5, finish: 11}
  end

  def test_ignores_spaces_and_tabs
    assert_parse "  text \t search   ",
      {type: :bare, value: "text", raw: "text", start: 2, finish: 6},
      {type: :bare, value: "search", raw: "search", start: 9, finish: 15}
  end

  def test_quoted_text_single
    assert_parse "'  text \t search   '",
      {type: :quoted, value: "  text \t search   ", raw: "'  text \t search   '", start: 0, finish: 20}
  end

  def test_quoted_text_double
    assert_parse "\"  text \t search   \"",
      {type: :quoted, value: "  text \t search   ", raw: "\"  text \t search   \"", start: 0, finish: 20}
  end

  def test_eacape_character
    assert_parse "'\\''",
      {type: :quoted, value: "'", raw: "'\\''", start: 0, finish: 4}
  end

  def test_broken_quotes
    assert_parse "'test",
      {type: :bare, value: "'test", raw: "'test", start: 0, finish: 5}

    # shall it recognize quotes here?
    assert_parse "t'test'",
      {type: :bare, value: "t'test'", raw: "t'test'", start: 0, finish: 7}

    # but it recognizes it here
    assert_parse "'test't",
      {type: :quoted, value: "test", raw: "'test'", start: 0, finish: 6},
      {type: :bare, value: "t", raw: "t", start: 6, finish: 7}

    assert_parse "'''",
      {type: :quoted, value: "", raw: "''", start: 0, finish: 2},
      {type: :bare, value: "'", raw: "'", start: 2, finish: 3}
  end

  def test_param
    assert_parse "param:1",
      {type: :param, name: "param", value: "1", raw: "param:1", start: 0, finish: 7}
  end

  def test_param_quoted_value
    assert_parse "param:'1 2'",
      {type: :param, name: "param", value: "1 2", raw: "param:'1 2'", start: 0, finish: 11}
  end

  def test_quote_before_params
    assert_parse "'param:1'",
      {type: :quoted, value: "param:1", raw: "'param:1'", start: 0, finish: 9}

    # this is most likely an error in user input
    assert_parse "'param:1",
      {type: :param, name: "'param", value: "1", raw: "'param:1", start: 0, finish: 8}

    assert_parse "param':1",
      {type: :param, name: "param'", value: "1", raw: "param':1", start: 0, finish: 8}

    # shall it support quoted params?
    assert_parse "'param':1",
      {type: :quoted, value: "param", raw: "'param'", start: 0, finish: 7},
      {type: :bare, value: ":1", raw: ":1", start: 7, finish: 9}
  end

  def test_strange_strings
    assert_parse "\n",
      {type: :bare, value: "\n", raw: "\n", start: 0, finish: 1}

    assert_parse "🤷‍♀️:1",
      {type: :param, name: "🤷‍♀️", value: "1", raw: "🤷‍♀️:1", start: 0, finish: 6}
  end
end
