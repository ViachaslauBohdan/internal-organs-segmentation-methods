import matlab.engine
from http.server import BaseHTTPRequestHandler, HTTPServer
import time


hostName = "localhost"
hostPort = 9000
eng = matlab.engine.start_matlab()
ret = eng.fn(1.0, 5.0)


class MyServer(BaseHTTPRequestHandler):
    def do_GET(self):
        self.send_response(200)
        self.send_header("Content-type", "text/html")
        self.end_headers()
        self.wfile.write(
            bytes("<html><head><title>Tomography images processing</title></head>", "utf-8"))
        self.wfile.write(bytes("<body><p>Server is running</p>", "utf-8"))
        self.wfile.write(bytes("</body></html>", "utf-8"))
        f = codecs.open("test.html", 'r', 'utf-8')


myServer = HTTPServer((hostName, hostPort), MyServer)
print(time.asctime(), "Server Starts - %s:%s" % (hostName, hostPort))
print(ret)

try:
    myServer.serve_forever()
except KeyboardInterrupt:
    pass

myServer.server_close()
print(time.asctime(), "Server Stops - %s:%s" % (hostName, hostPort))
