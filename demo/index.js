'use strict';

var net = require('net'),
	Hue = require('hue'),
	hue = new Hue(),
	config = require('./config.json'),
	client;

hue.on('bridge', function(ip, info) {
	if (!(ip in config))
		hue.select(ip, null).configuration.createUser('huege#hackathon', null, function(err, response) {
			if (err) throw err;
			console.log('User created:', response.body);
			select(ip, response.body.username);
		});
	else
		select(ip, config[ip].username);

	function select(ip, username) {
		var buffer = '';

		hue.select(ip, username);

		client = net.connect(1230, 'hue-hackathon.pauldenotter.com', function() {
			console.log('Connected');
		}),

		client.on('data', function(chunk) {
			var ids, data, chunks, newlineIndex;

			buffer += chunk.toString();
			while (true) {
				if (!buffer.length) break;

				newlineIndex = buffer.indexOf('\r\n')
				if (newlineIndex < 0) return;

				data = JSON.parse(buffer.slice(0, newlineIndex));
				buffer = buffer.slice(newlineIndex+2);

				if (['light', 'group'].indexOf(data.type) < 0) return;

				ids = data.id;
				if (!(ids instanceof Array)) ids = [ids];

				if (!data.body.transitiontime) data.body.transitiontime = 40;

				ids.forEach(function(id) {
					hue[data.type + 's'].setState(id, data.body, function(err, response) {
						if (err) console.error(err);
//						console.log(response)
					});
				});
			}
		});
	}
}).discover();
