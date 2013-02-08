require 'source-map-support'
tsort = require '../src/tsort.coffee'

describe "tsort", ->
  describe "simple graph", ->
    describe "should return ordered", ->
      it "letters", ->

        # A -> B -> C -> D

        #given
        edges = [["A", "B"], ["B", "C"], ["C", "D"]]

        #when
        sorted = tsort(edges)

        #then
        sorted.should.eql [ "A", "B", "C", "D" ]

      it "letters - many childrens", ->

        # A -> B -> C 
        #      | -> D
        #      \ -> E

        #given
        edges = [["A", "B"], ["B", "C"], ["B", "D"], ["B", "E"]]

        #when
        sorted = tsort(edges)

        #then
        sorted.should.eql [ "A", "B", "E", "D", "C" ]

      it "letters - many childrens more than one node", ->

        # A -> B -> C 
        # |    | -> D
        # |
        # \ -> E

        #given
        edges = [["A", "B"], ["B", "C"], ["B", "D"], ["A", "E"]]

        #when
        sorted = tsort(edges)

        #then
        sorted.should.eql [ "A", "E", "B", "D", "C" ]


      it "numbers", ->

        #given
        edges = [
          [1, 2], 
          [1, 3], 
          [2, 4], 
          [3, 4]]

        #when
        sorted = tsort(edges)

        #then
        sorted.should.eql [ 1, 3, 2, 4 ]

      it "big graph", ->

        #given
        edges = [
          [91, 25], [21, 88], [90, 61], [50, 61], 
          [41, 24], [55, 81], [71, 77], [50, 19], 
          [20, 51], [15, 67], [86, 14], [58, 79], 
          [21, 71], [50, 7], [57, 22], [27, 74], 
          [32, 27], [21, 83], [70, 31], [70, 49], 
          [53, 90], [24, 42], [75, 20], [49, 84], 
          [59, 25], [8, 97], [63, 83], [55, 42], 
          [30, 73], [80, 57]]

        #when
        sorted = tsort(edges)

        #then
        sorted.should.eql [91, 86, 80, 75, 70, 63, 59, 58, 
          79, 57, 55, 81, 53, 90, 50, 
          61, 49, 84, 41, 32, 31, 30, 
          73, 27, 74, 25, 24, 42, 22, 
          21, 83, 71, 77, 88, 20, 51, 
          19, 15, 67, 14, 8, 97, 7]

  describe "closed chain", ->
    it "should throw a error", ->

      # A -> B
      #  \---|

      #given
      edges = [["A", "B"], ["B", "A"]]

      #when
      f = -> tsort(edges)

      #then
      f.should.throw(/^closed chain/)

    it "should throw a error", ->

      # A -> B -> C
      #  \--------|

      #given
      edges = [["A", "B"], ["B", "C"], ["C", "A"]]

      #when
      f = -> tsort(edges)

      #then
      f.should.throw(/^closed chain/)

    it "should throw a error", ->

      # A -> B -> C -> D
      #  \-------------|

      #given
      edges = [["A", "B"], ["B", "C"], ["C", "D"], ["D", "A"]]

      #when
      f = -> tsort(edges)

      #then
      f.should.throw(/^closed chain/)

    it "should throw a error", ->

      # A -> B -> C -> D
      #       \--------|

      #given
      edges = [["A", "B"], ["B", "C"], ["C", "D"], ["D", "B"]]

      #when
      f = -> tsort(edges)

      #then
      f.should.throw(/^closed chain/)