var clients = [],
	buffer = [],
	MongoClient = require('mongodb').MongoClient,
	collection;

module.exports = function(client) {
	MongoClient.connect('mongodb://127.0.0.1/hackathon', function(err, db) {
		if (err) throw err;

		collection = db.collection('psvmatch');

		console.log('Client connected ');
		clients.push(client);

		client.on('end', function() {
			console.log('Client disconnected');
			clients.splice(clients.indexOf(client), 1);
		});

		client.on('data', receive);
		client.write('Hackathoooon\r\n');
	});
};

function receive(incomingBuffer) {
	var split = incomingBuffer.toString().split(';'),
		data = {
			ts: new Date(),
			avg: parseFloat(split[0], 10),
			peak: parseFloat(split[1], 10)
		};

	buffer.push(data);
	collection.insert(data, function(err, docs) {
		if (err) console.error(err);
	});
}

function sendData(data) {
	if ('string' !== typeof data)
		data = (data instanceof Object) ? JSON.stringify(data) : data + '';

	clients.forEach(function(client) {
		client.write(data);
	});
}

setInterval(function() {
	var bufferContents = buffer.slice(0),
		avg;

	if (!bufferContents.length) return;

	buffer = [];

	avg = bufferContents.map(function(data) {
		return data.avg;
	}).reduce(function(a, b) {
		return a + b;
	}) / bufferContents.length;

	sendData(avg);
}, 4000);
