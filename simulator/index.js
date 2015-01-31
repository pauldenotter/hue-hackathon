'use strict';

var net = require('net'),
	matchEvents = require('./events.json'),
	port = 1230;

net.createServer(function(client) {
	console.log('client connected');
	var ts = new Date(),
		events = Array.prototype.slice.call(matchEvents, 0),
		diff = ts.getTime() - (new Date(events[0].ts)).getTime(),
		interval;

	if (!events.length) return;

	client.on('error', function(err) {
		console.error(err);
	});

	interval = setInterval(function() {
		var event;

		while ((new Date(events[0].ts)).getTime() <= (new Date()).getTime() - diff) {
			event = events.shift();
			console.log(event);
			client.write(JSON.stringify(event) + '\r\n');
			if (!events.length) {
				clearInterval(interval);
				break;
			}
		}
	}, 250)
}).listen(port, function() {
	console.log('listening on port', port);
});
