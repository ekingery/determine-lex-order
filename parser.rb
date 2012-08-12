require 'tsort'

# Given a dictionary, parse it and return the alphabet
class Parser

  def initialize()
    # a hash representing a graph structure
    @hgraph   = {}
    @prev_word  = ''
  end

  # For each given word, check against the previous word
  # to find out if there is enough information to add a directed edge
  def add_word( new_word )

    # grab the first word and throw away anything after any whitespace
    new_word = new_word.split.shift
    if new_word.nil? or new_word.empty?
      return
    end
    new_word.downcase!

    if !@prev_word.empty?
      # insert a directed edge into the hash if one can be determined
      c1, c2 = str_lex_cmp(@prev_word, new_word)
      if (!c1.empty? and !c2.empty?)
        if @hgraph[c1].nil?
          @hgraph[c1] = [c2]
        else
          @hgraph[c1].push(c2)
        end
      end
    end
    @prev_word = new_word
  end

  # return the reverse of the topologically sorted hgraph
  def sort()
    begin
      sorted = @hgraph.tsort
    rescue TSort::Cyclic => ex
      $stderr.print ex, " due to cyclic input data\n"
      sorted = []
    end

    # tsort does a depth first search, so reverse the sorted output
    return sorted.reverse
  end

  def pretty_print(arr)
    i = 1;
    arr.each { |x|
      print "Letter ", "%02d" % i, " => ", x, "\n"
      i += 1
    }
  end

  # given two words, returns a directed edge (pair of characters)
  # representing the lexicographical order
  def str_lex_cmp( prev, cur )

    n   = 0;
    len = cur.length

    # loop for each character in the previous word
    prev.each_char {|c|
      if n >= len
        return ''
      end
      # if the characters do not match, we know something about the lexicography
      if (c != cur[n])
        return c, cur[n]
      end
      n += 1
    }

    # nothing was learned
    return ''
  end

end

# Mixin the Tarjan topological sorting algorithm with the hash class
class Hash
  include TSort

  # each node is a hash key, iterate over them using the standard each_key
  alias tsort_each_node each_key

  # child nodes are arrays of characters found to follow the key,
  # iterate over the array characters using the code block provided by tsort
  def tsort_each_child(node, &block)
    begin
      fetch(node).each(&block)
    rescue KeyError => ex
      # noop - work could be done here if desired to detect the difference
      # between a non strongly connected graph where uniqueness
      # is not guaranteed, and the case where a trivial 'last' node exists
      # (such as 'z' in the english alphabet) which is not strongly connected
      # Or, perhaps I don't understand the concepts or terminology well enough
      $stderr.print ex, " is not strongly connected\n"
    end
  end
end

