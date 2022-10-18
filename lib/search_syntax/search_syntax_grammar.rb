# Autogenerated from a Treetop grammar. Edits may be lost.

module SearchSyntaxGrammar
  include Treetop::Runtime

  def root
    @root ||= :root
  end

  module Root0
    def expressions
      elements[1]
    end
  end

  module Root1
    def value
      elements[1].value
    end
  end

  def _nt_root
    start_index = index
    if node_cache[:root].has_key?(index)
      cached = node_cache[:root][index]
      if cached
        node_cache[:root][index] = cached = SyntaxNode.new(input, index...(index + 1)) if cached == true
        @index = cached.interval.end
      end
      return cached
    end

    i0, s0 = index, []
    s1, i1 = [], index
    loop do
      r2 = _nt_space
      if r2
        s1 << r2
      else
        break
      end
    end
    r1 = instantiate_node(SyntaxNode, input, i1...index, s1)
    s0 << r1
    if r1
      r3 = _nt_expressions
      s0 << r3
      if r3
        s4, i4 = [], index
        loop do
          r5 = _nt_space
          if r5
            s4 << r5
          else
            break
          end
        end
        r4 = instantiate_node(SyntaxNode, input, i4...index, s4)
        s0 << r4
      end
    end
    if s0.last
      r0 = instantiate_node(SyntaxNode, input, i0...index, s0)
      r0.extend(Root0)
      r0.extend(Root1)
    else
      @index = i0
      r0 = nil
    end

    node_cache[:root][start_index] = r0

    r0
  end

  module Expressions0
  end

  module Expressions1
    def value
      elements.map { |e|
        e.elements[0].value.merge({
          raw: e.elements[0].text_value,
          start: e.elements[0].interval.begin,
          finish: e.elements[0].interval.end
        })
      }
    end
  end

  def _nt_expressions
    start_index = index
    if node_cache[:expressions].has_key?(index)
      cached = node_cache[:expressions][index]
      if cached
        node_cache[:expressions][index] = cached = SyntaxNode.new(input, index...(index + 1)) if cached == true
        @index = cached.interval.end
      end
      return cached
    end

    s0, i0 = [], index
    loop do
      i1, s1 = index, []
      i2 = index
      r3 = _nt_quoted_value
      if r3
        r3 = SyntaxNode.new(input, (index - 1)...index) if r3 == true
        r2 = r3
      else
        r4 = _nt_param
        if r4
          r4 = SyntaxNode.new(input, (index - 1)...index) if r4 == true
          r2 = r4
        else
          r5 = _nt_bare_value
          if r5
            r5 = SyntaxNode.new(input, (index - 1)...index) if r5 == true
            r2 = r5
          else
            @index = i2
            r2 = nil
          end
        end
      end
      s1 << r2
      if r2
        r7 = _nt_space
        r6 = r7 || instantiate_node(SyntaxNode, input, index...index)
        s1 << r6
      end
      if s1.last
        r1 = instantiate_node(SyntaxNode, input, i1...index, s1)
        r1.extend(Expressions0)
      else
        @index = i1
        r1 = nil
      end
      if r1
        s0 << r1
      else
        break
      end
    end
    r0 = instantiate_node(SyntaxNode, input, i0...index, s0)
    r0.extend(Expressions1)
    r0.extend(Expressions1)

    node_cache[:expressions][start_index] = r0

    r0
  end

  def _nt_space
    start_index = index
    if node_cache[:space].has_key?(index)
      cached = node_cache[:space][index]
      if cached
        node_cache[:space][index] = cached = SyntaxNode.new(input, index...(index + 1)) if cached == true
        @index = cached.interval.end
      end
      return cached
    end

    s0, i0 = [], index
    loop do
      if has_terminal?(@regexps[gr = '\A[ \\t]'] ||= Regexp.new(gr), :regexp, index)
        r1 = true
        @index += 1
      else
        terminal_parse_failure('[ \\t]')
        r1 = nil
      end
      if r1
        s0 << r1
      else
        break
      end
    end
    if s0.empty?
      @index = i0
      r0 = nil
    else
      r0 = instantiate_node(SyntaxNode, input, i0...index, s0)
    end

    node_cache[:space][start_index] = r0

    r0
  end

  module QuotedValue0
  end

  module QuotedValue1
  end

  module QuotedValue2
  end

  module QuotedValue3
  end

  module QuotedValue4
    def value
      quote = elements[0].text_value
      {
        type: :quoted,
        value: elements[1].text_value.gsub("\\#{quote}", quote)
      }
    end
  end

  def _nt_quoted_value
    start_index = index
    if node_cache[:quoted_value].has_key?(index)
      cached = node_cache[:quoted_value][index]
      if cached
        node_cache[:quoted_value][index] = cached = SyntaxNode.new(input, index...(index + 1)) if cached == true
        @index = cached.interval.end
      end
      return cached
    end

    i0 = index
    i1, s1 = index, []
    if (match_len = has_terminal?('"', false, index))
      r2 = true
      @index += match_len
    else
      terminal_parse_failure('\'"\'')
      r2 = nil
    end
    s1 << r2
    if r2
      s3, i3 = [], index
      loop do
        i4 = index
        if (match_len = has_terminal?('\"', false, index))
          r5 = instantiate_node(SyntaxNode, input, index...(index + match_len))
          @index += match_len
        else
          terminal_parse_failure('\'\\"\'')
          r5 = nil
        end
        if r5
          r5 = SyntaxNode.new(input, (index - 1)...index) if r5 == true
          r4 = r5
        else
          i6, s6 = index, []
          i7 = index
          if (match_len = has_terminal?('"', false, index))
            r8 = true
            @index += match_len
          else
            terminal_parse_failure('\'"\'')
            r8 = nil
          end
          if r8
            @index = i7
            r7 = nil
            terminal_parse_failure('\'"\'', true)
          else
            @terminal_failures.pop
            @index = i7
            r7 = instantiate_node(SyntaxNode, input, index...index)
          end
          s6 << r7
          if r7
            if index < input_length
              r9 = true
              @index += 1
            else
              terminal_parse_failure("any character")
              r9 = nil
            end
            s6 << r9
          end
          if s6.last
            r6 = instantiate_node(SyntaxNode, input, i6...index, s6)
            r6.extend(QuotedValue0)
          else
            @index = i6
            r6 = nil
          end
          if r6
            r6 = SyntaxNode.new(input, (index - 1)...index) if r6 == true
            r4 = r6
          else
            @index = i4
            r4 = nil
          end
        end
        if r4
          s3 << r4
        else
          break
        end
      end
      r3 = instantiate_node(SyntaxNode, input, i3...index, s3)
      s1 << r3
      if r3
        if (match_len = has_terminal?('"', false, index))
          r10 = true
          @index += match_len
        else
          terminal_parse_failure('\'"\'')
          r10 = nil
        end
        s1 << r10
      end
    end
    if s1.last
      r1 = instantiate_node(SyntaxNode, input, i1...index, s1)
      r1.extend(QuotedValue1)
    else
      @index = i1
      r1 = nil
    end
    if r1
      r1 = SyntaxNode.new(input, (index - 1)...index) if r1 == true
      r0 = r1
      r0.extend(QuotedValue4)
      r0.extend(QuotedValue4)
    else
      i11, s11 = index, []
      if (match_len = has_terminal?("'", false, index))
        r12 = true
        @index += match_len
      else
        terminal_parse_failure("'\\''")
        r12 = nil
      end
      s11 << r12
      if r12
        s13, i13 = [], index
        loop do
          i14 = index
          if (match_len = has_terminal?("\\'", false, index))
            r15 = instantiate_node(SyntaxNode, input, index...(index + match_len))
            @index += match_len
          else
            terminal_parse_failure("'\\\\\\''")
            r15 = nil
          end
          if r15
            r15 = SyntaxNode.new(input, (index - 1)...index) if r15 == true
            r14 = r15
          else
            i16, s16 = index, []
            i17 = index
            if (match_len = has_terminal?("'", false, index))
              r18 = true
              @index += match_len
            else
              terminal_parse_failure("'\\''")
              r18 = nil
            end
            if r18
              @index = i17
              r17 = nil
              terminal_parse_failure("'\\''", true)
            else
              @terminal_failures.pop
              @index = i17
              r17 = instantiate_node(SyntaxNode, input, index...index)
            end
            s16 << r17
            if r17
              if index < input_length
                r19 = true
                @index += 1
              else
                terminal_parse_failure("any character")
                r19 = nil
              end
              s16 << r19
            end
            if s16.last
              r16 = instantiate_node(SyntaxNode, input, i16...index, s16)
              r16.extend(QuotedValue2)
            else
              @index = i16
              r16 = nil
            end
            if r16
              r16 = SyntaxNode.new(input, (index - 1)...index) if r16 == true
              r14 = r16
            else
              @index = i14
              r14 = nil
            end
          end
          if r14
            s13 << r14
          else
            break
          end
        end
        r13 = instantiate_node(SyntaxNode, input, i13...index, s13)
        s11 << r13
        if r13
          if (match_len = has_terminal?("'", false, index))
            r20 = true
            @index += match_len
          else
            terminal_parse_failure("'\\''")
            r20 = nil
          end
          s11 << r20
        end
      end
      if s11.last
        r11 = instantiate_node(SyntaxNode, input, i11...index, s11)
        r11.extend(QuotedValue3)
      else
        @index = i11
        r11 = nil
      end
      if r11
        r11 = SyntaxNode.new(input, (index - 1)...index) if r11 == true
        r0 = r11
        r0.extend(QuotedValue4)
        r0.extend(QuotedValue4)
      else
        @index = i0
        r0 = nil
      end
    end

    node_cache[:quoted_value][start_index] = r0

    r0
  end

  module BareValue0
  end

  module BareValue1
  end

  module BareValue2
    def value
      {
        type: :bare,
        value: elements[0].text_value
      }
    end
  end

  def _nt_bare_value
    start_index = index
    if node_cache[:bare_value].has_key?(index)
      cached = node_cache[:bare_value][index]
      if cached
        node_cache[:bare_value][index] = cached = SyntaxNode.new(input, index...(index + 1)) if cached == true
        @index = cached.interval.end
      end
      return cached
    end

    i0, s0 = index, []
    s1, i1 = [], index
    loop do
      i2, s2 = index, []
      i3 = index
      r4 = _nt_space
      @index = i3
      r3 = if r4
        nil
      else
        instantiate_node(SyntaxNode, input, index...index)
      end
      s2 << r3
      if r3
        if index < input_length
          r5 = true
          @index += 1
        else
          terminal_parse_failure("any character")
          r5 = nil
        end
        s2 << r5
      end
      if s2.last
        r2 = instantiate_node(SyntaxNode, input, i2...index, s2)
        r2.extend(BareValue0)
      else
        @index = i2
        r2 = nil
      end
      if r2
        s1 << r2
      else
        break
      end
    end
    if s1.empty?
      @index = i1
      r1 = nil
    else
      r1 = instantiate_node(SyntaxNode, input, i1...index, s1)
    end
    s0 << r1
    if r1
      if (match_len = has_terminal?("", false, index))
        r6 = true
        @index += match_len
      else
        terminal_parse_failure("''")
        r6 = nil
      end
      s0 << r6
    end
    if s0.last
      r0 = instantiate_node(SyntaxNode, input, i0...index, s0)
      r0.extend(BareValue1)
      r0.extend(BareValue2)
    else
      @index = i0
      r0 = nil
    end

    node_cache[:bare_value][start_index] = r0

    r0
  end

  def _nt_predicate
    start_index = index
    if node_cache[:predicate].has_key?(index)
      cached = node_cache[:predicate][index]
      if cached
        node_cache[:predicate][index] = cached = SyntaxNode.new(input, index...(index + 1)) if cached == true
        @index = cached.interval.end
      end
      return cached
    end

    i0 = index
    if (match_len = has_terminal?(">=", false, index))
      r1 = instantiate_node(SyntaxNode, input, index...(index + match_len))
      @index += match_len
    else
      terminal_parse_failure('">="')
      r1 = nil
    end
    if r1
      r1 = SyntaxNode.new(input, (index - 1)...index) if r1 == true
      r0 = r1
    else
      if (match_len = has_terminal?("<=", false, index))
        r2 = instantiate_node(SyntaxNode, input, index...(index + match_len))
        @index += match_len
      else
        terminal_parse_failure('"<="')
        r2 = nil
      end
      if r2
        r2 = SyntaxNode.new(input, (index - 1)...index) if r2 == true
        r0 = r2
      else
        if (match_len = has_terminal?("=>", false, index))
          r3 = instantiate_node(SyntaxNode, input, index...(index + match_len))
          @index += match_len
        else
          terminal_parse_failure('"=>"')
          r3 = nil
        end
        if r3
          r3 = SyntaxNode.new(input, (index - 1)...index) if r3 == true
          r0 = r3
        else
          if (match_len = has_terminal?("=<", false, index))
            r4 = instantiate_node(SyntaxNode, input, index...(index + match_len))
            @index += match_len
          else
            terminal_parse_failure('"=<"')
            r4 = nil
          end
          if r4
            r4 = SyntaxNode.new(input, (index - 1)...index) if r4 == true
            r0 = r4
          else
            if (match_len = has_terminal?("!=", false, index))
              r5 = instantiate_node(SyntaxNode, input, index...(index + match_len))
              @index += match_len
            else
              terminal_parse_failure('"!="')
              r5 = nil
            end
            if r5
              r5 = SyntaxNode.new(input, (index - 1)...index) if r5 == true
              r0 = r5
            else
              if (match_len = has_terminal?(">", false, index))
                r6 = true
                @index += match_len
              else
                terminal_parse_failure('">"')
                r6 = nil
              end
              if r6
                r6 = SyntaxNode.new(input, (index - 1)...index) if r6 == true
                r0 = r6
              else
                if (match_len = has_terminal?("<", false, index))
                  r7 = true
                  @index += match_len
                else
                  terminal_parse_failure('"<"')
                  r7 = nil
                end
                if r7
                  r7 = SyntaxNode.new(input, (index - 1)...index) if r7 == true
                  r0 = r7
                else
                  @index = i0
                  r0 = nil
                end
              end
            end
          end
        end
      end
    end

    node_cache[:predicate][start_index] = r0

    r0
  end

  module Param0
  end

  module Param1
  end

  module Param2
    def value
      result = {
        type: :param,
        name: elements[0].text_value,
        value: elements[3].value[:value]
      }
      predicate = elements[2].text_value
      if predicate != ""
        result[:predicate] = predicate.to_sym
      end
      result
    end
  end

  def _nt_param
    start_index = index
    if node_cache[:param].has_key?(index)
      cached = node_cache[:param][index]
      if cached
        node_cache[:param][index] = cached = SyntaxNode.new(input, index...(index + 1)) if cached == true
        @index = cached.interval.end
      end
      return cached
    end

    i0, s0 = index, []
    s1, i1 = [], index
    loop do
      i2, s2 = index, []
      i3 = index
      i4 = index
      r5 = _nt_space
      if r5
        r5 = SyntaxNode.new(input, (index - 1)...index) if r5 == true
        r4 = r5
      else
        if (match_len = has_terminal?(":", false, index))
          r6 = true
          @index += match_len
        else
          terminal_parse_failure('":"')
          r6 = nil
        end
        if r6
          r6 = SyntaxNode.new(input, (index - 1)...index) if r6 == true
          r4 = r6
        else
          @index = i4
          r4 = nil
        end
      end
      if r4
        @index = i3
        r3 = nil
        terminal_parse_failure("(any alternative)", true)
      else
        @terminal_failures.pop
        @index = i3
        r3 = instantiate_node(SyntaxNode, input, index...index)
      end
      s2 << r3
      if r3
        if index < input_length
          r7 = true
          @index += 1
        else
          terminal_parse_failure("any character")
          r7 = nil
        end
        s2 << r7
      end
      if s2.last
        r2 = instantiate_node(SyntaxNode, input, i2...index, s2)
        r2.extend(Param0)
      else
        @index = i2
        r2 = nil
      end
      if r2
        s1 << r2
      else
        break
      end
    end
    if s1.empty?
      @index = i1
      r1 = nil
    else
      r1 = instantiate_node(SyntaxNode, input, i1...index, s1)
    end
    s0 << r1
    if r1
      if (match_len = has_terminal?(":", false, index))
        r8 = true
        @index += match_len
      else
        terminal_parse_failure('":"')
        r8 = nil
      end
      s0 << r8
      if r8
        r10 = _nt_predicate
        r9 = r10 || instantiate_node(SyntaxNode, input, index...index)
        s0 << r9
        if r9
          i11 = index
          r12 = _nt_quoted_value
          if r12
            r12 = SyntaxNode.new(input, (index - 1)...index) if r12 == true
            r11 = r12
          else
            r13 = _nt_bare_value
            if r13
              r13 = SyntaxNode.new(input, (index - 1)...index) if r13 == true
              r11 = r13
            else
              @index = i11
              r11 = nil
            end
          end
          s0 << r11
        end
      end
    end
    if s0.last
      r0 = instantiate_node(SyntaxNode, input, i0...index, s0)
      r0.extend(Param1)
      r0.extend(Param2)
    else
      @index = i0
      r0 = nil
    end

    node_cache[:param][start_index] = r0

    r0
  end
end

class SearchSyntaxGrammarParser < Treetop::Runtime::CompiledParser
  include SearchSyntaxGrammar
end
