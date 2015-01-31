'use strict';

var net = require('net'),
	client = net.connect(8215, 'hue-hackathon.pauldenotter.com', function() {
		console.log('Connected');
	});

client.on('data', function(buffer) {
	console.log(buffer.toString());
});
