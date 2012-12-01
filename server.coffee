express = require 'express'
app = express()

app.set 'view engine', 'jade'
app.use express.static("public")
app.use require('connect-assets')()

app.get '/', (req, res)->
  res.render 'index'

app.listen 3000
