import matlab.engine
from flask import Flask,url_for
from flask import render_template, request
from flask import jsonify
from flask_cors import CORS
import unicodedata

app = Flask(__name__)
# app._static_folder = './static'
CORS(app)

matlab_engine = matlab.engine.start_matlab()

def normalize_unicode_string(data):
    return unicodedata.normalize('NFKD', data).encode('ascii','ignore')

@app.route("/")
def hello():
    return "Hello World!"

@app.route("/images")
def images():
        return render_template('main.html')

@app.route("/seed",methods = ['GET'])
def showResult():    
    if request.method == 'GET':
        # payload  = request.get_json()
        image_name = normalize_unicode_string(request.args.get('fileName'))
        distance_ratio = normalize_unicode_string(request.args.get('ratio'))
        distance_type = normalize_unicode_string(request.args.get('distance'))
        neigbr_number = normalize_unicode_string(request.args.get('neighboursNumber'))
        

        outpit_img = matlab_engine.seed_mean_py(image_name,float(distance_ratio),distance_type,int(neigbr_number),nargout=1)   
        print(outpit_img);  
        return jsonify({'result':str(outpit_img)})

@app.route("/matlab")
def matlab():
    return "some matlab content"

if __name__ == "__main__":
    app.debug = True
    app.run()


