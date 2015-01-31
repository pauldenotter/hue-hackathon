var clients = [],
	buffer = [];

module.exports = function(client) {
	console.log('Client connected ');
	clients.push(client);

	client.on('end', function() {
		console.log('Client disconnected');
		clients.slice(clients.indexOf(client), 1);
	});

	client.on('data', receive);

	client.write('Hackathoooon\r\n');
};

function receive(buffer) {
	var split = buffer.toString().split(';'),
		data = {
			ts: new Date(),
			avg: parseFloat(split[0], 10),
			peak: parseFloat(split[1], 10)
		};

	console.log(data);
}

setInterval(function() {
	var bufferContents = buffer,
		avg;
	buffer = [];

	avg = bufferContents.map(function(data) {
		return data.avg;
	}).reduce(function(a, b) {
		return a + b;
	}) / bufferContents.length;

	console.log(avg);
}, 4000);
