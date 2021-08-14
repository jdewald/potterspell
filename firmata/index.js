// Require your Transport!
const Serialport = require("serialport");
// Get the Firmata class without a bound transport. 
const Firmata = require("firmata-io").Firmata;

Serialport.list().then(ports => {
  // Figure which port to use...
  const port = ports.find(port => port.manufacturer && port.manufacturer == "FTDI" );
  
  console.log("Opening {}", port.comName);
  // Instantiate an instance of your Transport class
  const transport = new Serialport(port.comName, "57600");

  // Pass the new instance directly to the Firmata class
  console.log("Instantiating...");
  const board = new Firmata(transport);

  board.on("open", () => console.log("Open"));
 board.on("queryfirmware", () => {
    console.log("  ✔ queryfirmware");  });

  board.on("reportversion", () => console.log(board.version.major));
  board.on("error", (err) => console.log(err));
  board.on("ready", () => { console.log("Ready!"); blink(board); }); 

  board.reportVersion(() => console.log("Got report"));
  board.queryFirmware(() => console.log("Got firmware"));
  board.on("close", () => {
    // Unplug the board to see this event!
    console.log("Closed!");
  });
});

function blink(board) {
	console.log("Turning on");
	board.digitalWrite(13, Firmata.HIGH);
	setTimeout(() => { 
		console.log("Turning off");
		board.digitalWrite(13, Firmata.LOW)
		setTimeout(() => blink, 1000);
	}, 500);
}
