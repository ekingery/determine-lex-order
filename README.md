determine-lex-order
===================

Ruby solution for determining an alphabet given a lexicographically ordered list of words.

------------------------------------------------------------------

### tl;dr

    ./determine_lex_order test/alphabet.txt
    ./determine_lex_order test/Chicago_Street_Names.csv

### What?

You've been given the input (attached), comprised of a sequence of words that are arranged in alphabetical order (for some arbitrary alternate alphabet). Given this file, we would like you to return an ordered sequence of the letters that comprise the alphabet used to sort this list of terms.

### How?

By [cheating](http://stackoverflow.com/a/3123591/1078587), of course.

More specifically, each pair of words from the dictionary are compared in an
attempt to determine a set of vertices with directed edges between them. The
directed edge represents that node A is ordered before node B in the alphabet. 
If the dictionary contains enough facts to represent a directed,
acyclic graph where every character is represented in a node, then the alphabet can be uniquely determined by sorting the graph. The solution does output a non unique alphabet when given non connected (incomplete) input data.

