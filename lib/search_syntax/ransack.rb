# frozen_string_literal: true

require_relative "ransack_transformer"

module SearchSyntax
  class Ransack
    # text - symbol. Idea for the future: it can be callback to allow to manipulate query for full-text search
    # params - array of strings; or hash to rename params
    # sort - string. nil - to disbale parsing sort param
    def initialize(text:, params:, sort: nil)
      @transformer = RansackTransformer.new(text: text, params: params, sort: sort)
      @parser = Parser.new
    end

    def parse_with_errors(text)
      @transformer.transform_with_errors(@parser.parse(text || "").value)
    end

    def parse(text)
      parse_with_errors(text)[0]
    end
  end
end
