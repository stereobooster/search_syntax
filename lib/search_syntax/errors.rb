# frozen_string_literal: true

module SearchSyntax
  class DuplicateParamError < StandardError
    attr_reader :name, :start, :finish

    def initialize(name:, start:, finish:)
      @name = name
      @start = start
      @finish = finish

      super("Duplicate parameter '#{name}' at position #{start}.")
    end
  end

  class UnknownParamError < StandardError
    attr_reader :name, :start, :finish, :did_you_mean

    def initialize(name:, start:, finish:, did_you_mean:)
      @name = name
      @start = start
      @finish = finish
      @did_you_mean = did_you_mean

      message = "Unknown parameter '#{name}' at position #{start}."
      if did_you_mean[0]
        message += " Did you mean '#{did_you_mean[0]}'?"
      end

      super(message)
    end
  end
end
