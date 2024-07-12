const http = require('http');

// Heroku portunu al, eğer yoksa 3000 portunu kullan
const port = process.env.PORT || 3000;

const server = http.createServer((req, res) => {
  res.statusCode = 200;
  res.setHeader('Content-Type', 'text/plain');
  res.end('Hello, World!\n');
});

server.listen(port, () => {
  console.log(`Server running on port ${port}`);
});