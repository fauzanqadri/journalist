require 'mechanize/cookie_jar'
module Journalist
  class CookieJar < ::Mechanize::CookieJar

    def to_chrome
      cookies = []
      JSON.parse(self.to_json, symbolize_names: true).each do |hash|
        cookies << {
          domain: hash[:domain],
          name: hash[:name],
          path: hash[:path],
          url: "#{(hash[:secure] ? 'https' : 'http')}://#{hash[:domain]}#{hash[:path]}",
          value: hash[:value],
          secure: hash[:secure]
        }
      end
      cookies
    end
  end
end
