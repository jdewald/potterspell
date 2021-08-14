var SerialPort = require("serialport");

SerialPort.list().then(ports => {
  // Figure which port to use...
  const port = ports.find(port => port.manufacturer && port.manufacturer == "FTDI" );

sport = new SerialPort(port.comName, "57600");
console.dir(port);
sport.open(function () {
  console.log('open');
  sport.on('data', function(data) {
    console.log('data received: ' + data);
  });
  sport.write("ls\n", function(err, results) {
    console.log('err ' + err);
    console.log('results ' + results);
  });
});
});
