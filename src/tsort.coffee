# Copyright 2012 Shin Suzuki<shinout310@gmail.com>
 
#    Licensed under the Apache License, Version 2.0 (the "License");
#    you may not use this file except in compliance with the License.
#    You may obtain a copy of the License at
 
#        http://www.apache.org/licenses/LICENSE-2.0
 
#    Unless required by applicable law or agreed to in writing, software
#    distributed under the License is distributed on an "AS IS" BASIS,
#    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#    See the License for the specific language governing permissions and
#    limitations under the License.
   
# https://gist.github.com/shinout/1232505
module.exports = tsort = (edges) ->
  nodes = {} # hash: stringified id of the node => { id: id, afters: lisf of ids }
  sorted = [] # sorted list of IDs ( returned value )
  visited = {} # hash: id of already visited node => true
  Node = (id) ->
    @id = id
    @afters = []
    return

  
  # 1. build data structures
  edges.forEach (v) ->
    from = v[0]
    to = v[1]
    nodes[from] = new Node(from)  unless nodes[from]
    nodes[to] = new Node(to)  unless nodes[to]
    nodes[from].afters.push to
    return

  
  # 2. topological sort
  Object.keys(nodes).forEach visit = (idstr, ancestors) ->
    node = nodes[idstr]
    id = node.id
    
    # if already exists, do nothing
    return  if visited[idstr]
    ancestors = []  unless Array.isArray(ancestors)
    ancestors.push id
    visited[idstr] = true
    node.afters.forEach (afterID) ->
      # if already in ancestors, a closed chain exists.
      throw new Error("closed chain : " + afterID + " is in " + id)  if ancestors.indexOf(afterID) >= 0
      visit afterID.toString(), ancestors.map((v) -> # recursive call
        v
      )
      return

    sorted.unshift id

  sorted