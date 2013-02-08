require 'source-map-support'
Rehab = require '../src/rehab'

describe "rehab", ->
  describe "processDependencyList", ->
    it "should return a ordered list", ->
      #given
      files = [["fileA", "fileB"], ["fileB", "fileC"], ["fileC", "fileD"]]

      #when
      rehab = new Rehab()
      sorted = rehab.processDependencyList files

      #then
      sorted.should.eql [ 'fileA', 'fileB', 'fileC', 'fileD' ]

    it "with MAIN info, should return a ordered list", ->
      REQ_MAIN_NODE = "*MAIN*"
      
      #given
      files = [[REQ_MAIN_NODE, "fileB"], ["fileB", "fileC"], [REQ_MAIN_NODE, "fileB"]]

      #when
      rehab = new Rehab()
      sorted = rehab.processDependencyList files

      #then
      sorted.should.eql [ REQ_MAIN_NODE, 'fileB', 'fileC' ]