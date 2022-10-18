# frozen_string_literal: true

require_relative "lib/search_syntax/version"

Gem::Specification.new do |spec|
  spec.name = "search_syntax"
  spec.version = SearchSyntax::VERSION
  spec.authors = ["stereobooster"]
  spec.email = ["stereobooster@gmail.com"]

  spec.summary = "Advanced search string"
  spec.description = "Advanced search string"
  spec.homepage = "https://github.com/stereobooster/search_syntax"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.6.0"

  spec.metadata["allowed_push_host"] = "https://rubygems.org/"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/stereobooster/search_syntax"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "treetop", "~> 1.6"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
