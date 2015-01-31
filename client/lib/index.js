'use strict';

var net = require('net');

net.connect(8215, 'hue-hackathon.pauldenotter.com', function(buffer) {
	console.log(buffer.toString());
});
