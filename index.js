const express = require('express')
const app = express()

PORT = process.env.PORT || 30000

app.get('/', function (req, res) {
  res.send('Hello World!')
})

app.listen(PORT, function () {
  console.log(`HELLO WORLD listening on port ${PORT}!`)
})
