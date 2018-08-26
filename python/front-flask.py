import matlab.engine
from flask import Flask,url_for
from flask import render_template, request
from flask import jsonify
from flask_cors import CORS

app = Flask(__name__)
# app._static_folder = './static'
CORS(app)

eng = matlab.engine.start_matlab()


print('ret works')

@app.route("/")
def hello():
    return "Hello World!"

@app.route("/images")
def images():
        return render_template('images.html')

@app.route("/images",methods = ['POST'])
def showResult():
    if request.method == 'POST':
        callback = eng.fn(1.0,5.0)
        return jsonify({'result':callback})

@app.route("/matlab")
def matlab():
    return "some matlab content"

if __name__ == "__main__":
    app.debug = True
    app.run()