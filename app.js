var express = require("express");
var app = express();

app.get("/", function (req, res) {
  res.status(200).send("Hello World!");
});

app.get("/ping", function (req, res) {
  res.status(200).send("Pong!");
});

app.get("/health", function (req, res) {
  if (Math.random() * 10 > 9) {
    return res.status(500).send();
  }
  res.status(200).send();
});

app.listen(3000, function () {
  console.log("App listening on port 3000!");
});
