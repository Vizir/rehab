# Rehab

Rehab helps you deal with your coffee dependency

## Why do you think you're here?

If you need to work with multiples CoffeeScript files and need to join then into a single JavaScript file at the end, Rehab is wating for you. 

You won't immediately realize you have a problem. Just a few .coffee files here and there and all you need is ```coffee --join``` to make it work.

Then, one day, you realize you need more! You need your files to have order or it won't work properly. And that little friend transpiler won't help. You start making maneuvers, like huge Cakefiles and even file lists(!), to deal with that. But one day you stop and think "There should be a better way to do that! I need help!"

Yes, we know... That's why we are here.


## No, no, no!

Rehab deals with coffeescript dependency using a simple tag ```#_require [filename]``` on the file that have dependencies.

```coffeescript
#_require ../filenameA.coffee
#_require ../filenameB.coffee

class app.Model2

```

With that on your troublesome files and Rehab will give you a list of files in the right order so you can use it, for instance, with your Cakefile:

```coffeescript
{exec} = require 'child_process'
Rehab = require 'rehab'

task 'build', 'Build coffee2js using Rehab', sbuild = ->
  console.log "Building project from src/*.coffee to lib/app.js"

  files = new Rehab().process './src'
  
  to_single_file = "--join lib/app.js"
  from_files = "--compile #{files.join ' '}"

  exec "coffee #{to_single_file} #{from_files}", (err, stdout, stderr) ->
    throw err if err
```

## License

©2012 David Lojudice Sobrinho and available under the [MIT license](http://www.opensource.org/licenses/mit-license.php):

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.