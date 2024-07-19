const http = require('http');

// Render platformunda `PORT` environment variable kullanılır
const port = process.env.PORT || 4000;

// Heroku veya Render gibi platformlar dinamik host kullanır
const hostname = '0.0.0.0';

const server = http.createServer((req, res) => {
  if (req.url.startsWith('/app2')) {
    res.statusCode = 200;
    res.setHeader('Content-Type', 'text/plain');
    res.end('Hello, Fatih Bey!\n');
  } else {
    res.statusCode = 200;
    res.setHeader('Content-Type', 'text/plain');
    res.end('Hello from my-node2-app!\n');
  }
});

server.listen(port, hostname, () => {
  console.log(`Server running at http://${hostname}:${port}/`);
});