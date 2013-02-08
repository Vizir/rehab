#_require ./tsort

wrench = require('wrench')
fs = require('fs')
tsort = require('./tsort')

module.exports = class Rehab

  String::beginsWith = (str) -> if @match(new RegExp "^#{str}") then true else false
  String::endsWith = (str) -> if @match(new RegExp "#{str}$") then true else false

  REQ_TOKEN: "#_require"
  REQ_MAIN_NODE: "*MAIN*"

  process: (folder) ->
    depInfo = @processDependencyInfo(folder)
    console.log depInfo
    @processDependencyList depInfo

  processDependencyInfo: (folder) ->
    depInfo = []
    for f in (@getSourceFiles folder)
      @parseRequiredFile folder, f, depInfo
    depInfo

  processDependencyList: (depInfo) ->
    depList = tsort(depInfo)
    depList.filter (i) -> i isnt @REQ_MAIN_NODE

  getSourceFiles: (folder) -> 
    files = wrench.readdirSyncRecursive folder 
    (file for file in files when file.endsWith '.coffee')

  parseRequiredLine: (line) ->
    line.replace "#{@REQ_TOKEN} ", ""

  parseRequiredFile: (folder, file, depInfo) ->
    depInfo.push [file, @REQ_MAIN_NODE] #every file depends on MAIN

    content = fs.readFileSync(folder + file, 'utf8')
    lines = content.split '\n'
    for line in lines
      depInfo.push [file, @parseRequiredLine(line)] if line.beginsWith @REQ_TOKEN