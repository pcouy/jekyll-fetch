# JekyllHttp

This plugin adds a new `fetch` filter that allows you to include content from an HTTP URL.

## Installation

Install the gem and add to the application's Gemfile by executing:

    $ bundle add jekyll-fetch

Add the plugin to your `_config.yml`:

```yaml
plugins:
  - jekyll-fetch
```

## Usage

Simply pass the URL you want to fetch the content from to the filter :

```
{{ "https://raw.githubusercontent.com/pcouy/jekyll-fetch/main/README.md" | fetch }}
```

The example above will render to the raw markdown of this readme. You can chain it with the `markdownify` filter to render it :

```
{{ "https://raw.githubusercontent.com/pcouy/jekyll-fetch/main/README.md" | fetch  | markdownify }}
```

Additionally, this plugin contains helper filters that help you work with files from GitHub repositories :

```
{{ "gh_user/repo_name" | github_url }}
Will render to : https://github.com/gh_user/repo_name

{{ "gh_user/repo_name" | github_readme }}
Will render to the content of the `README.md` file from the repository

{{ "gh_user/repo_name" | github_file: "path/to/file/in/repo" }}
Will render to the content of the specified file from the repository
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

You can use your local development version of this plugin by modifying the `Gemfile` of your website to look like the following :

```
gem "jekyll-fetch", "~> VERSION", :path => "/path/to/your/local/jekyll-fetch"
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/pcouy/jekyll-fetch.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
