'use strict';

var net = require('net'),
	sound = require('./sound'),
	port = 8215;

net.createServer(sound).listen(port, function() {
	console.log('listening on port', port);
});
