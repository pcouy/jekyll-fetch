# frozen_string_literal: true

require_relative "jekyll-fetch/version"
require "liquid"
require "net/https"

module Jekyll
  module JekyllFetch
    class Error < StandardError; end

    def fetch(uri_str, limit = 10)
      # You should choose better exception.
      raise ArgumentError, 'HTTP redirect too deep' if limit == 0

      url = URI.parse(uri_str)
      req = Net::HTTP::Get.new(url.path, { 'User-Agent' => 'Mozilla/5.0 (etc...)' })
      response = Net::HTTP.start(url.host, url.port, use_ssl: true) { |http| http.request(req) }
      case response
      when Net::HTTPSuccess     then response.body
      when Net::HTTPRedirection then fetch(response['location'], limit - 1)
      else
        response.error!
      end
    end
  end
end

Liquid::Template.register_filter(Jekyll::JekyllFetch)
