require 'spec_helper'
require 'spoj/problem_parser'

describe 'Spoj::ProblemParser' do

  #describe '#parsing_logic' do
  #
  #  before :each do
  #    @parser = Spoj::ProblemParser.new
  #    @code = 'TEST'
  #    @url = "http://www.spoj.com/problems/#{@code}"
  #    @stub = stub_request(:get, @url).to_return(html_response("spoj/#{@code}.html"))
  #  end
  #
  #  it "should hit spoj.pl web site to get content" do
  #    @parser.parse_problem @code
  #    assert_requested @stub
  #  end
  #
  #  it "should detect problem name and number" do
  #    res = @parser.parse_problem @code
  #    res[:number].should == 1
  #    res[:name].should == 'Life, the Universe, and Everything'
  #  end
  #
  #  it "should detect content, input and output" do
  #    res = @parser.parse_problem @code
  #    res[:content].should == "Your program is to use the brute-force approach in order to find the Answer to Life, the Universe, and Everything. More precisely... rewrite small numbers from input to output. Stop processing input after reading in the number 42. All numbers at input are integers of one or two digits."
  #    res[:input].should == ''
  #    res[:output].should == ''
  #  end
  #
  #  it "should detect examples" do
  #    res = @parser.parse_problem @code
  #    examples = res[:examples]
  #    examples.length.should == 1
  #    example = examples[0]
  #    example[:input].should == "1\n2\n88\n42\n99\n"
  #    example[:output].should == "1\n2\n88\n"
  #  end
  #
  #  it "should detect problem infi" do
  #    res = @parser.parse_problem @code
  #    #res[:info][:added_by].should == "Michał Małafiejski"
  #    res[:info][:date].should == "2004-05-01"
  #    res[:info][:time_limit].should == "10s"
  #    res[:info][:source_limit].should == "50000B"
  #    res[:info][:memory_limit].should == "1536MB"
  #    res[:info][:cluster].should == "Cube (Intel Pentium G860 3GHz)"
  #    res[:info][:languages].should == "All"
  #    res[:info][:resource].should == "Douglas Adams, The Hitchhiker's Guide to the Galaxy"
  #  end
  #
  #end

  describe '#different_problems' do

    before :each do
      @parser = Spoj::ProblemParser.new
    end

    it "should pars PRIME1 problem" do
      code = 'PRIME1'
      url = "http://www.spoj.com/problems/#{code}"
      stub_request(:get, url).to_return(html_response("spoj/#{code}.html"))

      res = @parser.parse_problem code

      res[:number].should == 2
      res[:name].should == 'Prime Generator'

      res[:content].should == "Peter wants to generate some prime numbers for his cryptosystem. Help him! Your task is to generate all prime numbers between two given numbers!"
      res[:input].should == 'The input begins with the number t of test cases in a single line (t<=10). In each of the next t lines there are two numbers m and n (1 <= m <= n <= 1000000000, n-m<=100000) separated by a space.'
      res[:output].should == 'For every test case print all prime numbers p such that m <= p <= n, one number per line, test cases separated by an empty line.'

      examples = res[:examples]
      examples.length.should == 1
      example = examples[0]
      example[:input].should == "2\n1 10\n3 5\n"
      example[:output].should == "2\n3\n5\n7\n\n3\n5\n\n"
    end

  end

end