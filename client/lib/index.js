'use strict';

var net = require('net'),
	Hue = require('hue'),
	hue = new Hue(),
	baseline = -20,
	max = 0,
	client;

hue.on('bridge', function() {
	if (!(ip in config))
		hue.select(ip, null).configuration.createUser('huege#hackathon', null, function(err, response) {
			if (err) throw err;
			console.log('User created:', response.body);
			select(ip, response.body.username);
		});
	else
		select(ip, config[ip].username);

	function select(ip, username) {
		hue.select(ip, username);

		client = net.connect(8215, 'hue-hackathon.pauldenotter.com', function() {
			console.log('Connected');
		}),

		client.on('data', function(buffer) {
			var brightness = calculateBrightness(parseFloat(buffer.toString(), 10));
			console.log(brightness);
			hue.groups.setState('1', {
				brightness: brightness,
				transitiontime: 40
			}, function() {
				console.log(arguments);
			});
		});
	}

	function calculateBrightness(avg) {
		if (avg < baseline) avg = baseline;
		if (avg > max) avg = max;
		64          -       255
		baseline    -       max
	}

}).discover();
