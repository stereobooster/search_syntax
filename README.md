# search_syntax

The main idea of the gem is to provide advanced search as seen at:

- [Github](https://docs.github.com/en/search-github/getting-started-with-searching-on-github/understanding-the-search-syntax)
- Google
- Gmail
- etc.

There is a gem which does something similar - `search_cop`, but I think it does way too much which makes it harder to change it's behaviour according to your needs.

This gem is much slimer. It provides only parser for "advanced search", which in turn can be connected to any DB "adapter", for example, ransack, ...

## Installation

Install the gem and add to the application's Gemfile by executing:

    $ bundle add search_syntax

If bundler is not being used to manage dependencies, install the gem by executing:

    $ gem install search_syntax

## Usage

TODO: Write usage instructions here

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/search_syntax. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/[USERNAME]/search_syntax/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the SearchSyntax project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/search_syntax/blob/master/CODE_OF_CONDUCT.md).
