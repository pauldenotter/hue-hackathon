'use strict';

var net = require('net'),
	matchEvents = require('./events.json'),
	port = 1230,
	clients = [];

net.createServer(function(client) {
	console.log('client connected');
	clients.push(client);

	var ts = new Date(),
		events = Array.prototype.slice.call(matchEvents, 0),
		totalTime = (new Date(events[events.length-1])).getTime() - (new Date(events[0].ts)).getTime(),
		diff = ts.getTime() - (new Date(events[0].ts)).getTime(),
		interval;

	if (!events.length) return;

	client.on('error', function(err) {
		console.error(err);
	}).on('end', function() {
		console.log('Client disconnected');
		clients.splice(clients.indexOf(client), 1);
	});

	interval = setInterval(function() {
		var event;

		while ((new Date(events[0].ts)).getTime() <= (new Date()).getTime() - diff) {
			event = events.shift();
			console.log(event);
console.log((new Date()).getTime() - diff));
			if (!event.percentage) event.percentage = ((new Date()).getTime() - diff) * 100 / totalTime;

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
