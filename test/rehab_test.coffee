require 'source-map-support'
Rehab = require '../src/rehab'

describe "rehab", ->
  describe "normalizeFilePath", ->
    describe "should return a graph", ->
      it "normalized file path", ->
        #given
        files = [["fileA", "fileB"], ["./fileB", "fileC"]]

        #when
        rehab = new Rehab()
        sorted = rehab.normalizeFilename '.', files

        #then
        sorted.should.eql [["fileA.coffee", "fileB.coffee"], ["fileB.coffee", "fileC.coffee"]]

      it "normalized relative file path", ->
        #given
        files = [["src/model/mode1", "../repo/repo1"], ["src/view/view1", "../model/model1"]]

        #when
        rehab = new Rehab()
        sorted = rehab.normalizeFilename '.', files

        #then
        sorted.should.eql [["src/model/mode1.coffee", "src/repo/repo1.coffee"], ["src/view/view1.coffee", "src/model/model1.coffee"]]

      it "normalized relative file path", ->
        #given
        files = [["src/model/mode1", "../repo/repo1"], ["src/view/view1", "../model/model1"]]

        #when
        rehab = new Rehab()
        sorted = rehab.normalizeFilename './project/', files

        #then
        sorted.should.eql [["project/src/model/mode1.coffee", "project/src/repo/repo1.coffee"], ["project/src/view/view1.coffee", "project/src/model/model1.coffee"]]

  describe "processDependencyList", ->
    describe "should return a ordered list when", ->
      it  "sequence dependence", ->
        #given
        files = [["fileA", "fileB"], ["fileB", "fileC"], ["fileC", "fileD"]]

        #when
        rehab = new Rehab()
        sorted = rehab.processDependencyList files

        #then
        sorted.should.eql [ 'fileA', 'fileB', 'fileC', 'fileD' ]

      it "only one dependence informed", ->
        REQ_MAIN_NODE = "__MAIN__"

        #given
        files = [[REQ_MAIN_NODE, "fileB"], ["fileB", "fileC"], [REQ_MAIN_NODE, "fileC"]]

        #when
        rehab = new Rehab()
        sorted = rehab.processDependencyList files

        #then
        sorted.should.eql [ 'fileB', 'fileC' ]

    