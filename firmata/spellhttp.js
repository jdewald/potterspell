const app = require('express')();
const port = 3000;
var five = require("johnny-five"), board = new five.Board();

var led = null;
var light = null;
board.on("ready", function() {
 led = new five.Led(12);
 light = new five.Led(4);
});

app.get('/lumos', (request, response) => {
  console.log("LUMOS");
  if (light) {
    light.on();
    response.send("On!");
  } else {
    response.send("Not yet initialized");
  }
});

app.get('/alohomora', (request, response) => {
  console.log("ALOHOMORA");
  if (led) {
    led.on();
    response.send("On!");
  } else {
    response.send("Not yet initialized");
  }
});
app.get('/allohomora', (request, response) => {
  console.log("ALLOHOMORA");
  if (led) {
    led.on();
    response.send("On!");
  } else {
    response.send("Not yet initialized");
  }
});

app.get("/nox", (request, response) => {
  console.log("NOX");
  light.stop();
  light.off();
  response.send("Off!");
});

app.get("/colloportus", (request, response) => {
  console.log("colloportus");
  led.stop();
  led.off();
  response.send("Off!");
});
app.get("/silencio", (request, response) => {
  console.log("silencio");
  led.stop();
  led.off();

  response.send("Off!");
});


app.listen(port, (err) => {
  if (err) {
    return console.log('something bad happened', err)
  }

  console.log(`server is listening on ${port}`)
})
