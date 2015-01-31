var clients = [];

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
			avg: split[0],
			peak: split[1]
		};

	console.log(data);
}
