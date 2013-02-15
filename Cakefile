{exec, spawn} = require 'child_process'
Rehab = require './lib/index'

build = ->
  console.log "Building project from src/*.coffee to lib/rehab.js"
  
  files = new Rehab().process './src'
  files = files.join " "

  join_to_single_file = "--join lib/rehab.js"
  compile_from_files = "--compile #{files}"

  exec "coffee #{join_to_single_file} #{compile_from_files}", (err, stdout, stderr) ->
    throw err if err

task 'build', 'Build coffee2js using Rehab', sbuild = ->
  build()