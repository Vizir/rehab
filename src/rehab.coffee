#_require ./tsort

wrench = require('wrench')
fs = require('fs')
tsort = require('./tsort')
path = require('path')

module.exports = class Rehab

  String::beginsWith = (str) -> if @match(new RegExp "^#{str}") then true else false
  String::endsWith = (str) -> if @match(new RegExp "#{str}$") then true else false

  REQ_TOKEN: "#_require"
  REQ_MAIN_NODE: "__MAIN__"

  process: (folder) ->
    # create a graph from a folder name: 
    # C <- A -> B.coffee -> C
    depGraph = @processDependencyGraph(folder)
    console.log "1: processDependencyGraph", depGraph

    # normalize filenames: 
    # C.coffee <- A.coffee -> B.coffee -> C.coffee
    depGraph = @normalizeFilename(folder, depGraph)
    console.log "2: normalizeFilename", depGraph

    # create a graph from a folder name: 
    # A.coffee -> B.coffee -> C.coffee
    depList = @processDependencyList depGraph
    console.log "3: processDependencyList", depList
    depList

  processDependencyGraph: (folder) ->
    depGraph = []
    for f in (@getSourceFiles folder)
      @parseRequiredFile folder, f, depGraph
    depGraph
  
  normalizeFilename: (folder, depGraph) ->
    # [[./fileA, fileB]] => [[fileA, fileB]]
    for edge in depGraph
      file = edge[1]
      continue if file == @REQ_MAIN_NODE

      fileDep = @normalizeCoffeeFilename(edge[0])
      fileDep = path.normalize fileDep

      file = @normalizeCoffeeFilename(file)
      
      fullPath = path.resolve path.dirname(fileDep), file
      file = path.join(folder, path.relative(folder, fullPath))
      edge[0..1] = [fileDep, file]
    depGraph

  normalizeCoffeeFilename: (file) ->
    file = "#{file}.coffee" unless file.endsWith ".coffee"
    file


  processDependencyList: (depGraph) ->
    depList = tsort(depGraph)
    depList.filter (i) => not i.beginsWith @REQ_MAIN_NODE

  getSourceFiles: (folder) -> 
    files = wrench.readdirSyncRecursive folder 
    (file for file in files when file.endsWith '.coffee')

  parseRequiredLine: (line) ->
    line.replace "#{@REQ_TOKEN} ", ""

  parseRequiredFile: (folder, file, depGraph) ->
    fileName = path.join(folder, file)
    depGraph.push [fileName, @REQ_MAIN_NODE] #every file depends on MAIN (a fake file)

    content = fs.readFileSync(fileName, 'utf8')
    lines = content.split '\n'
    for line in lines
      depGraph.push [fileName, @parseRequiredLine(line)] if line.beginsWith @REQ_TOKEN