'use strict';

var net = require('net'),
	sound = require('./sound');

net.createServer(sound).listen(8215);
