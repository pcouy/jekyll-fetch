# frozen_string_literal: true

require_relative 'jekyll-fetch/version'
require 'liquid'
require 'net/https'

module Jekyll
  # Filters for transforming URL strings into the content at the URL
  module JekyllFetch
    class Error < StandardError; end

    # Helper functions for HTTP requests
    class Utils
      class << self
        def fetch(uri_str, limit = 10)
          raise ArgumentError, 'Max retries reached' if limit.zero?

          begin
            unsafe_fetch(uri_str, limit)
          rescue Errno::ECONNREFUSED
            Jekyll.logger.warn "Connection refused for #{uri_str}, retrying in 2s..."
            sleep 2
            Jekyll.logger.warn "Retrying (#{limit - 1} tries left)"
            fetch(uri_str, limit - 1)
          end
        end

        private

        def unsafe_fetch(uri_str, limit)
          raise ArgumentError, 'Max retries reached' if limit.zero?

          response_to_body(
            uri_to_response(uri_str), limit - 1
          )
        end

        def uri_to_response(uri_str)
          url = URI.parse(uri_str)
          req = Net::HTTP::Get.new(url.path, { 'User-Agent' => 'Mozilla/5.0 (etc...)' })
          Net::HTTP.start(url.host, url.port, use_ssl: true) { |http| http.request(req) }
        end

        def response_to_body(response, limit)
          case response
          when Net::HTTPSuccess     then response.body.force_encoding('UTF-8')
          when Net::HTTPRedirection then fetch(response['location'], limit)
          else
            response.error!
          end
        end
      end
    end

    def fetch(uri_str, limit = 10)
      raise ArgumentError, 'HTTP redirect too deep' if limit.zero?

      Jekyll.logger.debug "fetch(#{uri_str})"
      Utils.fetch(uri_str, limit)
    end

    def github_url(repo)
      "https://github.com/#{repo}"
    end

    def github_readme(repo)
      Jekyll.logger.debug "github_readme(#{repo})"
      github_file repo, 'README.md'
    end

    def github_file(repo, file)
      Jekyll.logger.debug "github_file(#{repo}, #{file})"
      fetch "#{github_url(repo)}/raw/main/#{file}"
    end
  end
end

Liquid::Template.register_filter(Jekyll::JekyllFetch)
