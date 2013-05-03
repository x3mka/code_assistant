require 'nokogiri'
require 'open-uri'
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
      doc = Nokogiri::HTML(open(url))

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
      p = doc.xpath("//p[@align='justify']").first

      state = :content

      sibling = p.next_sibling
      while (!sibling.nil? && sibling.name != 'hr') do
        if sibling.name == 'h3'
          state = :input if sibling.content =~ /Input/
          state = :output if sibling.content =~ /Output/
          state = :raw_example if sibling.content =~ /Example/
          sibling = sibling.next_sibling
          next
        end
        res[state.to_sym] += sibling.to_s
        sibling = sibling.next_sibling
      end

      res[:content] = cleanup_text res[:content]
      res[:input] = cleanup_text res[:input]
      res[:output] = cleanup_text res[:output]

      # example
      return res if res[:raw_example].empty?

      res[:raw_example] =~ /<pre>(<strong>.*Input.*<\/strong>\s*)(.*)\n(<strong>.*Output.*<\/strong>\s*)(.*)<\/pre>/m
      res[:examples] << {:input => $2, :output => $4 }

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
      text = Nokogiri::XML::DocumentFragment.parse(text).content
      text = text.split("\n").each {|line| line.strip! }.select {|line| !line.blank?}.join(' ')
      text
    end

  end
end