'use strict';

var net = require('net'),
	matchEvents = require('./events.json'),
	port = 1230;

net.createServer(function(client) {
	var ts = new Date(),
		events = Array.prototype.slice.call(matchEvents, 0),
		diff = ts.getTime() - clientEvents[0].ts.getTime(),
		interval;

	if (!clientEvents.length) return;

	client.on('error', function(err) {
		console.error(err);
	});

	var interval = setInterval(function() {
		var event;

		while (events[0].ts <= (new Date()).getTime() - diff) {
			event = events.shift();
			console.log(event);
		}
	}, 250)

	clientEvents.foreach(function(event) {
		client.write(JSON.stringify(event));
	});
}).listen(port, function() {
	console.log('listening on port', port);
});
