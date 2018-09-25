import matlab
import matlab.engine
from flask import Flask, url_for
from flask import render_template, request
from flask import jsonify
from flask_cors import CORS
import unicodedata
import json
import numpy as np


app = Flask(__name__)
CORS(app)
matlab_engine = matlab.engine.start_matlab()

kmeans_arrays = []


def normalize_unicode_string(data):
    return unicodedata.normalize('NFKD', data).encode('ascii', 'ignore')
    


@app.route("/")
def hello():
    return "Hello World!"


@app.route("/images")
def images():
    return render_template('main.html')


@app.route("/seed", methods=['GET', 'POST'])
def startSeedProcessing():
    import matlab
    print('SEED REQUEST')
    if request.method == 'POST':
        payload = request.get_json()
        xSeedsCoordinates = []
        ySeedsCoordinates = []
        image_name = normalize_unicode_string(request.args.get('fileName'))
        distance_ratio = normalize_unicode_string(request.args.get('ratio'))
        distance_type = normalize_unicode_string(request.args.get('distance'))
        neigbr_number = normalize_unicode_string(
            request.args.get('neighboursNumber'))

        for el in payload['coordsArray']:
            xSeedsCoordinates.append(el['x'])
            ySeedsCoordinates.append(el['y'])

        xSeedsMatlabCoordinates = matlab.double(xSeedsCoordinates)
        ySeedsMatlabCoordinates = matlab.double(ySeedsCoordinates)
        

        output_img = matlab_engine.multiple_seeds_py(image_name, float(distance_ratio), distance_type, int(neigbr_number),
                                                     xSeedsMatlabCoordinates, ySeedsMatlabCoordinates, nargout=1)
        print(output_img)
        return jsonify({'result': output_img})


@app.route("/kmeans/step1", methods=['GET'])
def startKmeansStep1():
    if request.method == 'GET':
        image_name = normalize_unicode_string(request.args.get('fileName'))
        clusters_number = normalize_unicode_string(
            request.args.get('clustersNumber'))

        clustered_bin_images = matlab_engine.kmeans_py_step1(image_name, float(clusters_number), nargout=1)
        global kmeans_arrays
        kmeans_arrays = clustered_bin_images
        return jsonify({'arrayOfImgs': clustered_bin_images})

@app.route("/kmeans/step2", methods=['GET'])
def startKmeansStep2():
    import matlab    
    filter_number = normalize_unicode_string(request.args.get('filterNumber'))
    image_number = normalize_unicode_string(request.args.get('imgNumber'))    
    print(filter_number,image_number)

    img_to_process = matlab_engine.kmeans_py_step2(filter_number,matlab.logical(kmeans_arrays[int(image_number)-1]),nargout=1)  

    return jsonify({'img_to_process': img_to_process})



@app.route("/matlab")
def matlab():
    return "some matlab content"


if __name__ == "__main__":
    app.debug = True
    app.run(host='localhost', port=3000)
