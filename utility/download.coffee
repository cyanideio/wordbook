https = require 'https'
fs = require 'fs'
# HELPERS
# Download Function
download = (url, dest, cb) ->
  file = fs.createWriteStream(dest)
  request = https.get url, (response) ->
    response.pipe file
    file.on 'finish', ->
      file.close cb
      # close() is async, call cb after close completes.
  .on 'error', (err) ->
    # Handle errors
    fs.unlink dest
    # Delete the file async. (But we don't check the result)
    if cb then cb err.message

exports.download = download
