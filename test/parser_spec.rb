require_relative '../parser'

# unit test class for the lexicographical dictionary parser
describe Parser do

  let(:parser) { Parser.new }

  it "finds directed edges properly" do
    parser.str_lex_cmp('','').should eq ''
    parser.str_lex_cmp('','b').should eq ''
    parser.str_lex_cmp('a','').should eq ''
    parser.str_lex_cmp('a','a').should eq ''
    parser.str_lex_cmp('similar','similarly').should eq ''
    parser.str_lex_cmp('longer','long').should eq '' # bad input
    parser.str_lex_cmp('a','b').should eq ['a', 'b']
    parser.str_lex_cmp('and','b').should eq ['a', 'b']
    parser.str_lex_cmp('and','bump').should eq ['a', 'b']
    parser.str_lex_cmp('bump','and').should eq ['b', 'a']
  end

  it "can topologically sort a hash" do

    thash = {'z' => ['x','a'], 'x' => ['a']}
    thash.tsort.reverse.should eq ['z', 'x', 'a']

    thash = {
      'a' => ['c', 'f', 'b'],
      'f' => ['x'],
      'c' => ['f'],
      'b' => ['x', 'f', 'c']
    }
    thash.tsort.reverse.should eq ['a','b','c', 'f', 'x']

  end

  it "returns an empty array when given no input" do
    parser.sort.should eq []
  end

  it "returns an empty array for a single word input" do
    parser.add_word('Test single')
    parser.sort.should eq []
  end

  it "properly handles substrings and non alphabetic chars, stops on spaces" do
    # also test downcase and whitespace split
    parser.add_word('aPt')
    parser.add_word('Apple split test')
    parser.add_word('|stuff')
    parser.add_word('trap')
    parser.sort.should eq ['a', '|', 't', 'p']
  end

  it "properly handles 'dangling' components" do
    # t and l get stuck at the end
    parser.add_word('appt')
    parser.add_word('apple')
    parser.add_word('banana')
    # y and i get appended to the beginning
    parser.add_word('synonymous')
    parser.add_word('sinful')
    parser.sort.should eq ['y', 'i', 'a', 'b', 's', 't', 'l']
    # it wouldn't be a bad idea to verify the stdout messages here
    # for now this can be checked manually by looking at the stderr output
  end

  it "properly handles cyclic dependencies" do
    parser.add_word('aPt')
    parser.add_word('Apple split test')
    parser.add_word('pee comes after')
    parser.add_word('tee parser fall down and go boom')
    # it wouldn't be a bad idea to verify the stdout messages here
    # for now this can be checked manually by looking at the stderr output
    parser.sort.should eq []
  end

  it "parses a dictionary into an alphabet" do
    parser.add_word('zed')
    parser.add_word('xenv')
    parser.add_word('xens')
    parser.add_word('vat')
    parser.sort.should eq ['z', 'x', 'v', 's']
  end

end

