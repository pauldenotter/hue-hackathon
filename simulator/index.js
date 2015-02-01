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
		totalTime = (new Date(events[events.length-1].ts)).getTime() - (new Date(events[0].ts)).getTime(),
		starttime = events[0].ts,
		diff = ts.getTime() - (new Date(starttime)).getTime(),
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

		while ((new Date(startTime)).getTime() <= (new Date()).getTime() - diff) {
			var playTime = ((new Date()).getTime() - (new Date(events[0].ts)).getTime() - diff);
			event = events.shift();
			console.log(playTime);
			if (!event.percentage) event.percentage = playTime * 100 / totalTime;

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
