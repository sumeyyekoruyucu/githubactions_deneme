const http = require('http');

// Render platformunda `PORT` environment variable kullanılır
const port = process.env.PORT || 3000;

// Heroku veya Render gibi platformlar dinamik host kullanır
const hostname = '0.0.0.0';

const server = http.createServer((req, res) => {
  res.statusCode = 200;
  res.setHeader('Content-Type', 'text/plain');
  res.end('Hello, World!\n');
});

server.listen(port, hostname, () => {
  console.log(`Server running at http://${hostname}:${port}/`);
});