fs = require 'fs-plus'
path = require 'path'

magicCommentPattern = ///
  ^%\s*     # Optional whitespace.
  !TEX      # Magic marker.
  \s+       # Semi-optional whitespace.
  (\w+)     # [1] Captures the magic keyword. E.g. "root".
  \s*=\s*   # Equal sign wrapped in optional whitespace.
  (.*)      # [2] Captures everything following the equal sign.
  $         # EOL.
  ///

module.exports =
class MagicParser
  constructor: (filePath) ->
    @filePath = filePath

  parse: ->
    result = {}
    for line in lines = @getLines()
      match = line.match(magicCommentPattern)
      break unless match? # Stop parsing unless line is a magic comment.
      result[match[1]] = match[2]

    result

  getLines: ->
    unless fs.existsSync(@filePath)
      throw new Error("No such file: #{@filePath}")

    rawFile = fs.readFileSync(@filePath, {encoding: 'utf-8'})
    lines = rawFile.replace(/(\r\n)|\r/g, '\n').split('\n')
