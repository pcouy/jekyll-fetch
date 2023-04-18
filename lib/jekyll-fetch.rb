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
          raise ArgumentError, 'HTTP redirect too deep' if limit.zero?

          response_to_body(
            uri_to_response(uri_str), limit - 1
          )
        end

        private

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

      puts uri_str
      Utils.fetch(uri_str, limit)
    end
  end
end

Liquid::Template.register_filter(Jekyll::JekyllFetch)
