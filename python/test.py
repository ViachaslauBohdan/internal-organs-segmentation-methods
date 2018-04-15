import SimpleHTTPServer
import SocketServer
import matlab.engine

PORT = 8000

Handler = SimpleHTTPServer.SimpleHTTPRequestHandler

httpd = SocketServer.TCPServer(("", PORT), Handler)
eng = matlab.engine.start_matlab()
ret = eng.matlab(1.0,5.0)
print "serving at port", PORT
print ret
httt_response='fffffffffff'
httpd.serve_forever()


