require 'nokogiri'
require 'httparty'
require 'sanitize'

require 'active_support/lazy_load_hooks'
require 'active_support/i18n'
require 'active_support/core_ext/string'



module Spoj
  class ProblemParser

    def parse_problem (code)
      res = {
          :code => code,
          :content => '',
          :input => '',
          :output => '',
          :raw_example => '',
          :examples => [],
          :info => {}
      }
      url = "http://www.spoj.com/problems/#{code}"
      response = HTTParty.get(url)

      doc = Nokogiri::HTML(response.body)

      # name and number
      meta = doc.xpath("//meta[@content='spoj-pl:problem']").first
      return res if meta.blank?

      t = meta.next_sibling
      return res if t.blank?

      name_with_number = t.xpath('tr/td/h1').first.content
      name_with_number =~ /(\d+)\.\s*(.*)/

      res[:number] = $1.to_i
      res[:name] = $2

      # content, input, output
      response.body =~ /<p align="justify">(.*?(?=<h3>))(<h3>Input<\/h3>(.*)<h3>Output<\/h3>(.*))?<h3>Example<\/h3>\s+<pre>(.*)<\/pre>(.*)<hr>/m

      res[:content] = cleanup_text $1
      res[:input] = cleanup_text $3
      res[:output] = cleanup_text $4
      res[:raw_example] = $5
      res[:note] = cleanup_text $6

      # example
      return res if res[:raw_example].empty?

      res[:raw_example] =~ /(<(b|strong)>.*Input.*<\/(b|strong)>\s*)(.*)\n(<(b|strong)>.*Output.*<\/(b|strong)>\s*)(.*)/m
      res[:examples] << {:input => $4, :output => $8 }

      # info
      doc.xpath("//table[@class='probleminfo']/tr").each do |tr|
        tds = tr.xpath('td')
        key = tds[0].inner_text.underscore.gsub(" ", "_").gsub(":","")
        value = tds[1].inner_text
        value.strip!
        res[:info][key.to_sym] = value
      end

      res
    end

    def cleanup_text (text)
      #doc = Nokogiri::HTML::DocumentFragment.parse text
      #e = doc.errors
      #text = Sanitize.clean text
      text = '' if text.nil?

      %w[p b strong em br img].each do |tag|
        text = strip_tag text, tag
      end

      %w[&nbsp;].each do |bad|
        text = text.gsub bad, ''
      end

      text = text.split("\n").each {|line| line.strip! }.select {|line| !line.blank?}.join(' ')
      text
    end

    def strip_tag (text, tag)
      text = strip_open_tag text, tag
      text = strip_close_tag text, tag
      text
    end

    def strip_open_tag (text, tag)
      text.gsub /<\s*#{tag}.*?>/m, ''
    end

    def strip_close_tag (text, tag)
      text.gsub /<\s*\/\s*#{tag}\s*.*?>/m, ''
    end

  end
end