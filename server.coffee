express = require 'express'

module.exports = ->
  app = express()

  app.set 'view engine', 'jade'
  app.use express.favicon()
  app.use express.static("./public")
  app.use express.logger()
  app.use require('connect-assets')()

  app.get '/', (req, res)->
    res.render 'index'

  app.listen process.env.PORT || 3000
